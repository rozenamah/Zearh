import UIKit
import GoogleMaps

protocol MainPatientDisplayLogic: MainScreenDisplayLogic {
}

class MainPatientViewController: MainScreenViewController, MainPatientDisplayLogic {

    // MARK: Outlets
    
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
        router?.navigateToCallDoctor()
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    // MARK: Presenter methods

}
