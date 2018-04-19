import UIKit
import SwiftCake

protocol AcceptPatientDisplayLogic: class {
}

class AcceptPatientViewController: UIViewController, AcceptPatientDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: SCImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceLabel: UIButton!
    @IBOutlet weak var confirmationLabel: UILabel!
    

    // MARK: Properties
    var interactor: AcceptPatientBusinessLogic?
    var router: AcceptPatientRouter?
    
    // Delegate responsible for doctors action, whether accept or cancel patient
    weak var flowDelegate: DoctortFlowDelegate?
    var patientInfo: DoctorResult?

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
    
    private func customizePatientInfo() {
        avatarImageView.setAvatar(for: patientInfo?.user)
        nameLabel.text = patientInfo?.user.fullname
        priceLabel.text = "\(patientInfo?.visit.price)"
        feeLabel.text = "\(patientInfo?.visit.fee)"
        phoneNumber.setTitle("\(patientInfo?.visit.phone)", for: .normal)
        distanceLabel.setTitle("\(patientInfo?.visit.distance)", for: .normal)
    }

    // MARK: Event handling

    @IBAction func acceptAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .accept)
        
        // TODO: remove segue
        performSegue(withIdentifier: "end_visit_segue", sender: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
    
    @IBAction func patientDetailsAction(_ sender: Any) {
        router?.navigateToPatientsDetails()
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        router?.makeCall(to: "\(patientInfo?.visit.phone)")
    }
    
    @IBAction func mapAction(_ sender: Any) {
        
    }
    
    // MARK: Presenter methods
}
