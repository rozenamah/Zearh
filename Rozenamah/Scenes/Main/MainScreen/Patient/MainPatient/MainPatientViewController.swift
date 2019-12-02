import UIKit
import CoreLocation
import GoogleMaps
import Firebase

protocol PatientFlowDelegate: class {
    func changeStateTo(flowPoint: PatientFlow)
}

protocol MainPatientDisplayLogic: MainScreenDisplayLogic, PatientFlowDelegate {
    func displayMarkersWithNearbyDoctors(_ markers: [GMSMarker])
    func patientHasNoLocation()
    func patientHasNoPushPermission()
}

class MainPatientViewController: MainScreenViewController, MainPatientDisplayLogic {
    
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var pinImageVerticle: NSLayoutConstraint!
    
    // MARK: Outlets
    @IBOutlet var viewToHideWhenFormVisible: [UIButton]!
    
    // MARK: Properties
    var interactor: MainPatientBusinessLogic?
    var router: MainPatientRouter?
    var isFirst = true
    
    /// Contains all nearby displayed doctors
    fileprivate var nearbyDoctorsMarkers = [GMSMarker]()
    /// By this value we know we should not display nearby doctors
    fileprivate var shouldDisplayNearbyDoctors = true

    // MARK: Object lifecycle
    var timer = Timer()
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("Main patient deinit")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad() // Setup view is called in not called in subclass
        
        self.mapView.delegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        // check doctor account verified?
        if User.current?.doctor != nil {
            if !User.current!.doctor!.isVerified {
                timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(self.checkDoctorVerified)), userInfo: nil, repeats: true)
            }
        }
        
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
        

        //Check Visit Reguest for Doctor after every 10 seconds
//        LoginUserManager.sharedInstance.timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(self.checkVisitRequest)), userInfo: nil, repeats: true)
        
        interactor?.registerForNotifications()
    }
    
    
    
    @objc func checkDoctorVerified(){
        SplashWorker().fetchMyUser{ (user, error) in
            
            if let error = error {
                return
            }
            
            if let user = user {
                // Save user in current
                User.current = user
                
                if user.doctor!.isVerified {
                    if self.timer != nil {
                        self.timer.invalidate()
                    }
                    
                    let title = "generic.success".localized
                    let alert = UIAlertController(title: title, message: "generic.doctorVerified".localized, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "generic.ok".localized, style: UIAlertAction.Style.default, handler: { (action) in
                        self.router?.navigateToAppAfterAccountVerified()
                    }))
            
                    if let popoverController = alert.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = self.view.bounds
                    }
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }

    
    
    //not used after notification work
    func getVisitRequest()  {
        if LoginUserManager.sharedInstance.visitFound || isFirst {
            isFirst = false
            SplashWorker().fetchMyBooking { (refreshBooking, error) in
                if let refreshBooking = refreshBooking {
                    LoginUserManager.sharedInstance.lastBooking = refreshBooking
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
                    
                } else {
                    LoginUserManager.sharedInstance.visitFound = false
                    AppRouter.noVisit()
                }
            }
        }
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
    }

    // MARK: Event handling
    
    @IBAction func callDoctorAction(_ sender: Any) {
        
        router?.navigateToCallForm(withClosePrevious: false, completion: {
            // Hide all buttons when call doctor visible
            self.viewToHideWhenFormVisible.forEach { $0.isHidden = true }
        })
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    func changeStateTo(flowPoint: PatientFlow) {
        switch flowPoint {
        case .callDoctor:
            router?.navigateToCallForm()
        case .searchWith(let filters):
            
            interactor?.checkIfPermissionsEnabled(completion: { [weak self] (verified) in
                
                if !verified {
                    return
                }
                
                // Attach location to filters - if no filters, display error
                if let location = self?.interactor?.currentLocation {
                    filters.location = location
                    self?.router?.navigateToSearchScreen(withFilters: filters)
                }
            })
            
        case .accept(let doctor, let filters):
            router?.navigateToAcceptDoctor(withDoctor: doctor, byFilters: filters)
        case .waitForAccept(booking: let booking):
            // Save booking
            currentBooking = booking
            
            // Display alert with "Wait for doctor accept" message
            router?.navigateToWaitForAccept(withBooking: booking)
        case .pending:
            // Show all buttons when no form visible, "call doctor" is hidden
            viewToHideWhenFormVisible.forEach { $0.isHidden = false }
            router?.closeContainer()
        case .doctorLocation(let location):
            presentUser(in: location)
        case .noLocation:
            router?.navigateToNoLocation()
        case .noPushPermission:
            router?.navigateToNoPushPermission()
        }
    }
    
    // MARK: Presenter methods
    
    func removeCurrentDoctorLocation() {
        interactor?.returnToUserLocation()
        removePresentedUser()
    }
    
    /// Called when this screen receives notification about accepted booking
    func moveToDoctorLocation(inBooking booking: Booking) {
        // By this we disable interactor so it will not move camera to
        // current user location when we restart the app
        interactor?.firstLocationDisplayed = true
        
        // Remove nearby doctors markers
        nearbyDoctorsMarkers.forEach { $0.map = nil }
        // We do it because fetching nearby doctors may take longer then displaying current visit
        shouldDisplayNearbyDoctors = false
        
        let position = booking.visit.doctorLocation
        // Move camera so we can see patient location
        presentUser(in: position)
        
        var coordinates = position.coordinate
        coordinates.latitude -= 0.003
        let cameraPosition = GMSCameraPosition(target: coordinates, zoom: 15.0, bearing: 0.0, viewingAngle: 0.0)
        animateToPosition(cameraPosition)
    }
    
    func displayMarkersWithNearbyDoctors(_ markers: [GMSMarker]) {
        // Attach markers to map
        if shouldDisplayNearbyDoctors {
            markers.forEach { $0.map = mapView }
        }
        nearbyDoctorsMarkers = markers
    }
    
    func patientHasNoLocation() {
        changeStateTo(flowPoint: .noLocation)
    }
    
    func patientHasNoPushPermission() {
        changeStateTo(flowPoint: .noPushPermission)
    }
}

extension MainPatientViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print(gesture)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("MAP--> \(position.target.latitude) : \(position.target.longitude)")
        reverseGeocodeCoordinate(position.target)
       LoginUserManager.sharedInstance.newPatientLocation = position.target
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            
            print(lines.joined(separator: "\n"))

            self.lblAddress.text = lines.joined(separator: "\n")
            
//            let labelHeight = self.lblText.intrinsicContentSize.height
//            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
//                                                bottom: labelHeight, right: 0)
//
//            // 4
//            UIView.animate(withDuration: 0.25) {
//                self.pinImageVertical.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5) - 35
//                self.view.layoutIfNeeded()
//            }
        }
    }
}

