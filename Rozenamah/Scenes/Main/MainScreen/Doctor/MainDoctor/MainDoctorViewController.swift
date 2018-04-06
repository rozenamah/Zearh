import UIKit
import SwiftCake

protocol MainDoctorDisplayLogic: MainScreenDisplayLogic {
    func handle(error: Error)
    func markAsWaitingForRequests()
    func markAsRejectingRequests()
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
        if sender.isSelected {
            interactor?.stopReceivingRequests()
        } else {
            interactor?.startReceivingRequests()
        }
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    // MARK: Presenter methods
    
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
    
    func handle(error: Error) {
        requestsReceiveButton.isUserInteractionEnabled = true
        router?.showError(error)
    }
}