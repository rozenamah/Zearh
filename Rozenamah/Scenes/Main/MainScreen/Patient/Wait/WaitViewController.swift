import UIKit

protocol WaitDisplayLogic: class {
    func handle(error: Error)
    func found(doctor user: User)
}

class WaitViewController: UIViewController, WaitDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: WaitBusinessLogic?
    var router: WaitRouter?

    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?
    
    /// Filters for which we search doctors
    var filters: CallDoctorForm!
    
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
        
        // Start calling search immidatly after we reach this screen
        interactor?.searchForDoctor(withFilters: filters)
    }

    // MARK: View customization

    fileprivate func setupView() {
    }

    // MARK: Event handling
    
    @IBAction func cancelAction(_ sender: Any) {
        interactor?.cancelCurrentRequest()
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }
    
    // MARK: Presenter methods
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func found(doctor user: User) {
        flowDelegate?.changeStateTo(flowPoint: .accept(doctor: user))
    }
}
