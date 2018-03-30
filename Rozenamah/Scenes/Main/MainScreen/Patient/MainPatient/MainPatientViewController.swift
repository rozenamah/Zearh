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
