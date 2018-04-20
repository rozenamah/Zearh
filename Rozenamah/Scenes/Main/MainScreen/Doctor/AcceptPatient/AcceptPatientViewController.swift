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
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var confirmationLabel: UILabel!
    

    // MARK: Properties
    var interactor: AcceptPatientBusinessLogic?
    var router: AcceptPatientRouter?
    
    // Delegate responsible for doctors action, whether accept or cancel patient
    weak var flowDelegate: DoctortFlowDelegate?
    // Information about patient for doctor when he is about to accept or decline visit
    var visitInfo: VisitDetails! {
        didSet {
            customizePatientInfo()
        }
    }
    // Variable used for calculation acceptance time
    private  var minutes = 15

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
        setTimeLeftLabel()
    }
    private func setTimeLeftLabel() {
        
        var _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { (_) in
            self.confirmationLabel.text = "Confirm in \(self.minutes - 1) minutes to accept visit"
            self.minutes -= 1
        }
    }
    
    func customizePatientInfo() {
        let user = visitInfo.user
        let visit = visitInfo.visit
        avatarImageView.setAvatar(for: user)
        nameLabel.text = user.fullname
        priceLabel.text = "\(visit.price) SAR"
        phoneNumber.setTitle(visit.phone ?? "No phone number", for: .normal)
        distanceButton.setTitle("\(visit.distanceInKM) km from you", for: .normal)
        
        // If more then 10 kilometers, highlight distance to red
        distanceButton.tintColor = visit.distanceInKM > 10 ? .rmRed : .rmGray
        distanceButton.setTitleColor(.rmRed, for: .normal)
        
        // If fee > 0, show fee label
        feeLabel.isHidden = visit.fee <= 0
        feeLabel.text = "+ \(visit.fee) SAR for cancellation"
        
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
        router?.navigateToPatientDetails(visitInfo)
       
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if visitInfo?.visit.phone != nil {
            router?.makeCall(to: "\(visitInfo.visit.phone!)")
        }
    }
    
    @IBAction func mapAction(_ sender: Any) {
        
    }
    
    // MARK: Presenter methods
}
