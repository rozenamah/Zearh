import UIKit
import CoreLocation
import SwiftCake
import GoogleMaps
import Firebase
import Alamofire
import SwiftyJSON

protocol MainDoctorDisplayLogic: MainScreenDisplayLogic {
    func handle(error: Error)
    func markAsWaitingForRequests()
    func markAsRejectingRequests()
    func doctorHasNoLocation()
    func doctorHasNoPushPermission()
}

protocol DoctortFlowDelegate: class {
    func changeStateTo(flowPoint: DoctorFlow)
}

class MainDoctorViewController: MainScreenViewController, MainDoctorDisplayLogic, DoctortFlowDelegate {

    // MARK: Outlets
    @IBOutlet weak var requestsReceiveButton: SCButton!
    
    // MARK: Properties
    var interactor: MainDoctorBusinessLogic?
    var interactorNew: MainDoctorInteractor?
    var router: MainDoctorRouter?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("Main doctor deinit")
    }


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        interactor?.registerForNotifications()
        
        // check user delete account LastTime
        if User.current!.is_deleted {
            let title = "generic.welcomeBack".localized
            let alert = UIAlertController(title: title, message: "generic.recoverd".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "generic.ok".localized, style: UIAlertAction.Style.default, handler: { (action) in
                User.current!.is_deleted = false
            }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = self.view.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // newCode Check Visit Reguest for Doctor after every 10 seconds commented if notification work
//         LoginUserManager.sharedInstance.timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(self.checkVisitRequest)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        LoginUserManager.sharedInstance.timer.invalidate()
    }
    
  
    
    
    
    
    
    
    
    func getVisitRequest()  {
//        if !LoginUserManager.sharedInstance.visitFound {
            SplashWorker().fetchMyBooking { (refreshBooking, error) in
                if let refreshBooking = refreshBooking {
                    LoginUserManager.sharedInstance.visitFound = true
                    if LoginUserManager.sharedInstance.bookingStatus == nil {
                        LoginUserManager.sharedInstance.bookingStatus = refreshBooking.status
                        AppRouter.navigateTo(booking: refreshBooking)
                    } else {
                        if LoginUserManager.sharedInstance.bookingStatus != refreshBooking.status {
                            LoginUserManager.sharedInstance.bookingStatus = refreshBooking.status
                            AppRouter.navigateTo(booking: refreshBooking)
                        }
                    }
//                    if LoginUserManager.sharedInstance.bookingStatus != refreshBooking.status {
//                        LoginUserManager.sharedInstance.bookingStatus = refreshBooking.status
//                        LoginUserManager.sharedInstance.visitFound = true
//                        AppRouter.navigateTo(booking: refreshBooking)
//                    }
                } else {
                    LoginUserManager.sharedInstance.visitFound = false
                    AppRouter.noVisit()
                }
            }
//        }
    }
    
    @objc func checkVisitRequest(){
       getVisitRequest()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Add shadow to container
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.rmShadow.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: -1)
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
    }

    // MARK: View customization

    override func setupView() {
        super.setupView()
        router?.configureFirstScreen()
        
        // If doctor available at start - mark button as available
        requestsReceiveButton.setTitle("home.stopReceivingVisitRequests".localized, for: .selected)
        requestsReceiveButton.setTitle("home.startReceivingVisitRequests".localized, for: .normal)
        if User.current?.doctor?.isAvailable ?? false {
            markAsWaitingForRequests()
        } else {
            markAsRejectingRequests()
        }
    }
    
    // MARK: Event handling

    func removeCurrentPatientLocation() {
        interactor?.returnToUserLocation()
        removePresentedUser()
    }
    
    @IBAction func receiveRequestAction(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if sender.isSelected {
            interactor?.stopReceivingRequests()
        } else {
            interactor?.startReceivingRequests()
        }
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    func changeStateTo(flowPoint: DoctorFlow) {
        print(flowPoint)
        switch flowPoint {
        case .accepted(let booking):
            // Depending if cash or card we redirect to diffrent views
            LoginUserManager.sharedInstance.lastBooking = booking
            if booking.payment == .cash {
                router?.navigateToDoctorOnTheWay(onBooking: booking)
            } else {
                router?.navigateToWaitForPayment()
            }
            // Save booking
            currentBooking = booking
        case .cancel:
            router?.navigateToCancel()

            // Remove patient icon from map, move to doctor position and remove booking
            removeCurrentPatientLocation()
            currentBooking = nil
        case .arrived(let booking):
            LoginUserManager.sharedInstance.lastBooking = booking
            router?.navigateToEndVisit(withBooking: booking)
            
            // Save booking
            currentBooking = booking
        case .ended:
            
            // Remove patient icon from map, move to doctor position
            removePresentedUser()
            interactor?.returnToUserLocation()
            currentBooking = nil
        case .noLocation:
            router?.navigateToNoLocation()
        case .noPushPermission:
            router?.navigateToNoPushPermission()
        }
    }

    // MARK: Presenter methods
    
    /// Called when this screen receives notification about new booking
    func moveToPatientLocation(inBooking booking: Booking) {
        // By this we disable interactor so it will not move camera to
        // current user location when we restart the app
        interactor?.firstLocationDisplayed = true
        
        let position = booking.patientLocation
        // Move camera so we can see patient location
        presentUser(in: position)
        
        var coordinates = position.coordinate
        coordinates.latitude -= 0.003
        let cameraPosition = GMSCameraPosition(target: coordinates, zoom: 15.0, bearing: 0.0, viewingAngle: 0.0)
        animateToPosition(cameraPosition)
    }
    
    /// Called when show route between doctor and patient
    func moveToBoundLocations(inBooking booking: Booking) {
        interactor?.firstLocationDisplayed = true
        
        let position = booking.patientLocation
        // Move camera so we can see patient location
        presentUser(in: position)
        
        var coordinates = position.coordinate
        coordinates.latitude -= 0.003
        
        if !booking.latitude.isZero && !booking.longitude.isZero && !booking.visit.latitude.isZero && !booking.visit.longitude.isZero {
            var bounds = GMSCoordinateBounds()
            let doctorCoordinate = CLLocation(latitude: booking.visit.latitude, longitude: booking.visit.longitude)
            let patientCoordinate = CLLocation(latitude: booking.latitude, longitude: booking.longitude)
            bounds = bounds.includingCoordinate(doctorCoordinate.coordinate)
            bounds = bounds.includingCoordinate(patientCoordinate.coordinate)
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
            mapView.animate(with: update)
            
        }
    
        
    }
    
    func markAsRejectingRequests() {
        requestsReceiveButton.isUserInteractionEnabled = true
        requestsReceiveButton.isSelected = false
        
        // Change background depending on state
        requestsReceiveButton.backgroundColor = !requestsReceiveButton.isSelected ? .rmBlue : .white
    }
    
    func markAsWaitingForRequests() {
        requestsReceiveButton.isUserInteractionEnabled = true
        requestsReceiveButton.isSelected = true
        
        // Change background depending on state
        requestsReceiveButton.backgroundColor = !requestsReceiveButton.isSelected ? .rmBlue : .white
    }
    
    func doctorHasNoLocation() {
        requestsReceiveButton.isUserInteractionEnabled = true
        changeStateTo(flowPoint: .noLocation)
    }
    
    func doctorHasNoPushPermission() {
        requestsReceiveButton.isUserInteractionEnabled = true
        changeStateTo(flowPoint: .noPushPermission)
    }
    
    func handle(error: Error) {
        requestsReceiveButton.isUserInteractionEnabled = true
        router?.showError(error, sender: self.view)
    }
    
}

extension MainDoctorViewController {
    func drawRoute(myLat:String,myLng:String,pLat:String,pLng:String,booking:Booking){
//        self.mapView.clear()
        print(self.interactorNew?.firstMyLocation)
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(myLat),\(myLng)&destination=\(pLat),\(pLng)&key=AIzaSyD4YIMG6xuvbw8MQpthFVXLt4-yng6xzjk&model=driving"
        Alamofire.request(url).responseJSON { (response) in
            
            let json = JSON(response.data!)
            
            // get Routes and Directions
            let routes = json["routes"].arrayValue
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor(hex: "5BC0D0") ?? UIColor.blue
                polyline.map = self.mapView
                
//                 get Distance and Duration
                let legs = route["legs"].arrayValue
                for leg in legs {
                    let distance = leg["distance"].dictionary
                    let duration = leg["duration"].dictionary
//                    self.lblText.text = "\(distance?["text"]?.stringValue ?? "Not Found") \n \(String(describing: duration?["text"]?.stringValue ?? "Not Found"))"
                    print("\(distance?["text"]?.stringValue ?? "Not Found") \n \(String(describing: duration?["text"]?.stringValue ?? "Not Found"))")
                }
            }
        }
    }
}
