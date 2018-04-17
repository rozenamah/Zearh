import UIKit

protocol AcceptDoctorDisplayLogic: class {
}

class AcceptDoctorViewController: UIViewController, AcceptDoctorDisplayLogic, PaymentMethodDelegate {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: Properties
    var interactor: AcceptDoctorBusinessLogic?
    var router: AcceptDoctorRouter?
    
    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?
    
    /// Doctor which is presented to user in order to accept
    var doctor: User!

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
    
    @IBAction func callAction(_ sender: Any) {
        router?.makeACall("123456778")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }

    @IBAction func acceptAction(_ sender: Any) {
        router?.navigateToPaymentMethod()
    }
    
    func patientPayWith(_ type: PaymentMethod) {
        // TODO: Add logic
    }
    
    // MARK: Presenter methods
}
