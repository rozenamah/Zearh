import UIKit

protocol WaitDisplayLogic: class {
    func handle(error: Error)
    func found(doctor: VisitDetails)
    func noDoctorFoundMatchingCriteria()
    func visitCancelled()
}

class WaitViewController: UIViewController, WaitDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: Properties
    var interactor: WaitBusinessLogic?
    var router: WaitRouter?

    /// This screen can have different states depending on this case
    var state: WaitType! {
        didSet {
            performWaitAction()
        }
    }
    // Maximum time for patien to confirm payment
    var minutes = 10
    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?
    // Use this delegate if in doctor modules
    weak var doctorFlowDelegate: DoctortFlowDelegate?
    
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
    
    /// Called when new state is inserted
    /// App checks which action should be performed in screen
    private func performWaitAction() {
        guard let state = state else {
            return
        }
        
        // Mostly this button is visible, so we show it
        cancelButton.isHidden = false
        
        switch state {
        case .waitAccept(_):
            titleLabel.text = "Doctor needs to accept your visit request"
        case .waitSearch(let filters):
            titleLabel.text = "Please wait"
            // Start calling search immidatly after fitlers are changed
            interactor?.searchForDoctor(withFilters: filters)
        case .waitForPayDoctor:
            titleLabel.text = "Your patient needs to confirm payment within 10 minutes"
            cancelButton.isHidden = true
//            startCountingTimeLeft()
        case .waitForVisitEnd(_):
            titleLabel.text = "Wait until doctor ends your current visit"
            cancelButton.isHidden = true
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        guard let state = state else {
            return
        }
        
        switch state {
        case .waitAccept(let booking):
            router?.showCancelAlert(forBooking: booking)
        case .waitSearch(_):
            interactor?.cancelCurrentRequest()
            flowDelegate?.changeStateTo(flowPoint: .callDoctor)
        default:
            doctorFlowDelegate?.changeStateTo(flowPoint: .cancel)
        }
    }
    
    func cancelConfirmed(forBooking booking: Booking) {
        interactor?.cancel(booking: booking)
    }
    
    // MARK: Presenter methods
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func found(doctor: VisitDetails) {
        guard case let .waitSearch(filters) = state! else {
            return
        }
        
        flowDelegate?.changeStateTo(flowPoint: .accept(doctor: doctor, foundByFilters: filters))
    }
    
    func noDoctorFoundMatchingCriteria() {
        router?.showNoDoctorFound()
    }
    
    func visitCancelled() {
        
        // We don't have to call it, we will get notificaion which will close this window
        // flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }
    
    /// When waiting for patient to accept payment we are counting
    /// down so doctor know when user needs to confirm payment
    private func startCountingTimeLeft() {
        var _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] (timer)   in
            // Self is weak because we want to avoid retain cycle
            self?.titleLabel.text = "Your patient needs to confirm payment within \((self?.minutes)! - 1) minutes"
            if self?.minutes == 0 {
                timer.invalidate()
                return
            }
            self?.minutes -= 1
        }
    }
}
