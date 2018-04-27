import UIKit
import SwiftCake

protocol AcceptPatientDisplayLogic: class {
    func patientAccepted(with visitId: String)
    func patientRejected()
    func handle(error: Error)
}

class AcceptPatientViewController: ModalInformationViewController, AcceptPatientDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var confirmationLabel: UILabel!
    
    // MARK: Properties
    var interactor: AcceptPatientBusinessLogic?
    var router: AcceptPatientRouter?
    
    // Delegate responsible for doctors action, whether accept or cancel patient
    weak var flowDelegate: DoctortFlowDelegate?
    
    // Information about patient for doctor when he is about to accept or decline visit
    var booking: Booking! {
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
    }
    
    private func startTimeLeftCounter() {
        var _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] (timer)   in
            // Self is weak because we want to avoid retain cycle
            self?.confirmationLabel.text = "Confirm in \((self?.minutes)! - 1) minutes to accept visit"
            if self?.minutes == 0 {
                timer.invalidate()
                return
            }
            self?.minutes -= 1
        }
    }
    
    func customizePatientInfo() {
        fillInformation(with: booking.patient, andVisitInfo: booking.visit)
        startTimeLeftCounter()
    }

    // MARK: Event handling

    @IBAction func acceptAction(_ sender: Any) {
        interactor?.acceptPatient(for: booking)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        interactor?.rejectPatient(for: booking)
    }
    
    @IBAction func patientDetailsAction(_ sender: Any) {
        router?.navigateToPatientDetails()
       
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if booking.visit.user.phone != nil {
            router?.makeCall(to: "\(booking.visit.user.phone!)")
        }
    }
    
    @IBAction func mapAction(_ sender: Any) {
        
    }
    
    // MARK: Presenter methods
    
    func patientAccepted(with visitId: String) {
        flowDelegate?.changeStateTo(flowPoint: .accepted(booking: booking))
    }
    
    func patientRejected() {
        flowDelegate?.changeStateTo(flowPoint: .rejected)
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
}
