import UIKit

protocol WaitDisplayLogic: class {
}

class WaitViewController: UIViewController, WaitDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: WaitBusinessLogic?
    var router: WaitRouter?

    /// We use it to communicate flow to main screen
    var flowDelegate: PatientFlowDelegate?
    
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
    }

    // MARK: View customization

    fileprivate func setupView() {
    }

    // MARK: Event handling
    
    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // To Test
        flowDelegate?.changeStateTo(flowPoint: .acceptDoctor)
    }
    
    // MARK: Presenter methods
}
