import UIKit
import CoreLocation

protocol PatientFlowDelegate: class {
    func changeStateTo(flowPoint: PatientFlow)
}

protocol MainPatientDisplayLogic: MainScreenDisplayLogic, PatientFlowDelegate {
    func displayMarkersWithNearbyDoctors(_ markers: [GMSMarker])
}

class MainPatientViewController: MainScreenViewController, MainPatientDisplayLogic {

    // MARK: Outlets
    @IBOutlet var viewToHideWhenFormVisible: [UIButton]!
    
    // MARK: Properties
    var interactor: MainPatientBusinessLogic?
    var router: MainPatientRouter?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad() // Setup view is called in not called in subclass
        
        router?.configureFirstScreen() // Show call form at start
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
    }

    // MARK: Event handling
    
    @IBAction func callDoctorAction(_ sender: Any) {
        router?.openContainer(completion: {
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
            // Attach location to filters - if no filters, display error
            if let location = interactor?.currentLocation {
                filters.location = location
                router?.navigateToSearchScreen(withFilters: filters)
            } else {
                // TODO: No location! display error
            }
        case .accept(let doctor, let filters):
            router?.navigateToAcceptDoctor(withDoctor: doctor, byFilters: filters)
        case .waitForAccept(booking: let booking):
            router?.navigateToWaitForAccept(withBooking: booking)
        case .pending:
            // Show all buttons when no form visible
            viewToHideWhenFormVisible.forEach { $0.isHidden = false }
            router?.closeContainer()
        case .cancel:
            // TODO: Navigate somewhere
            break
        case .doctorLocation(location: let location):
            presentUser(in: location)
        }
    }
    
    // MARK: Presenter methods
    

    func displayMarkersWithNearbyDoctors(_ markers: [GMSMarker]) {
        // Attach markers to map
        markers.forEach { $0.map = mapView }
    }
}
