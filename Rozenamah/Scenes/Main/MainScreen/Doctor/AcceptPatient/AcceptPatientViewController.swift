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
    
    var flowDelegate: DoctortFlowDelegate?

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

    @IBAction func acceptAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .accept)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
    
    @IBAction func patientDetailsAction(_ sender: Any) {
        router?.navigateToPatientsDetails()
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        
    }
    
    @IBAction func mapAction(_ sender: Any) {
        
    }
    
    // MARK: Presenter methods
}
