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
    @IBOutlet weak var feeLabel: UILabel!
    
    // MARK: Properties
    var interactor: AcceptDoctorBusinessLogic?
    var router: AcceptDoctorRouter?
    
    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?
    
    /// Doctor which is presented to user in order to accept
    var doctor: VisitDetails! {
        didSet {
            fillUserData()
        }
    }
    
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
        
    }
    
    private func fillUserData() {
        // Fill doctor data
        let user = doctor.user
        let visit = doctor.visit
        
        doctorNameLabel.text = user.fullname
        classificationLabel.text = user.doctor?.classification.title
        priceLabel.text = "\(visit.price) SAR"
        phoneButton.setTitle(visit.phone ?? "No phone number", for: .normal)
        locationButton.setTitle("\(visit.distanceInKM) km from you", for: .normal)
        avatarImageView.setAvatar(for: user)
        
        // Without this phone number will rever title to previous one (it is a bug but source is uknown)
        phoneButton.setTitle(visit.phone ?? "No phone number", for: .highlighted)
        locationButton.setTitle("\(visit.distanceInKM) km from you", for: .highlighted)
        
        // If more then 10 kilometers, highlight distance to red
        locationButton.tintColor = visit.distanceInKM > 10 ? .rmRed : .rmGray
        
        // If fee > 0, show fee label
        feeLabel.isHidden = visit.fee <= 0
        feeLabel.text = "+ \(visit.fee) SAR for cancellation"
    }

    // MARK: Event handling
    
    @IBAction func callAction(_ sender: Any) {
        if let phone = doctor.visit.phone {
            router?.makeCall(to: phone)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        /// Add user to disabled doctors - it won't be displayed again
        filters.disabledDoctors.append(doctor.user)
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }

    @IBAction func acceptAction(_ sender: Any) {
        router?.navigateToPaymentMethod()
    }
    
    func patientPayWith(_ type: PaymentMethod) {
        
    }
    
    // MARK: Presenter methods
}
