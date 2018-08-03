import UIKit

protocol AcceptDoctorDisplayLogic: PaymentMethodDelegate {
}

class AcceptDoctorViewController: ModalInformationViewController, AcceptDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var classificationLabel: UILabel!
    
    // MARK: Properties
    var interactor: AcceptDoctorBusinessLogic?
    var router: AcceptDoctorRouter?
    
    var visitInfo: VisitDetails! {
        didSet {
            fillInformation(with: visitInfo.user, andVisitInfo: visitInfo)
        }
    }
    
    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?
    
    /// Filters by which doctor was found
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
    }

    // MARK: View customization

    fileprivate func setupView() {
        // Lower the font so it fits in iphone 4/5
        if iPhoneDetection.deviceType() == .iphone4 || iPhoneDetection.deviceType() == .iphone5 {
            
        }
    }
    
    override func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails) {
        super.fillInformation(with: user, andVisitInfo: visitInfo)
        phoneNumber.setTitle(user.phone ?? "No phone number", for: .normal)
        classificationLabel.text = visitInfo.user.doctor?.classification.title
    }

    // MARK: Event handling
    
    @IBAction func callAction(_ sender: Any) {
        if let phone = visitInfo.user.phone {
            router?.makeCall(to: phone)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        /// Add user to disabled doctors - it won't be displayed again
        filters.disabledDoctors.append(visitInfo.user)
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }

    @IBAction func acceptAction(_ sender: Any) {
        router?.navigateToPaymentMethod()
    }
    
    
    // MARK: Presenter methods
    
    /// Called when new booking created from "payment method" screen
    func new(booking: Booking) {
        flowDelegate?.changeStateTo(flowPoint: .waitForAccept(booking: booking))
    }
}
