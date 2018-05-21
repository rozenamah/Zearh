import UIKit
import CoreLocation
import SwiftCake
import GoogleMaps

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
        requestsReceiveButton.setTitle("Stop receiving visit requests", for: .selected)
        requestsReceiveButton.setTitle("Start receiving visit requests", for: .normal)
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
        switch flowPoint {
        case .accepted(let booking):
            // Depending if cash or card we redirect to diffrent views
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
        router?.showError(error)
    }
}
