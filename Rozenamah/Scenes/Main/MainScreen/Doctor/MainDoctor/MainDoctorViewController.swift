import UIKit
import SwiftCake

protocol MainDoctorDisplayLogic: MainScreenDisplayLogic {
}

class MainDoctorViewController: MainScreenViewController, MainDoctorDisplayLogic {

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

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        interactor?.registerForNotifications()
    }

    // MARK: View customization

    override func setupView() {
        super.setupView()
    }

    // MARK: Event handling

    @IBAction func receiveRequestAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        // Change background depending on state
        sender.backgroundColor = !sender.isSelected ? .rmBlue : .white
        
        // TODO: API
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    // MARK: Presenter methods
}
