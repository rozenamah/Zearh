import UIKit
import SwiftCake


protocol PaymentViewDelegate {
    func onPaymentDone()
}

protocol PaymentDisplayLogic: class {
    func displayPaymentProfileWith(profile: Payment.Details?)
    func handle(error: Error)
    func visitCancelled()
}

class PaymentViewController: UIViewController, PaymentDisplayLogic {
    
    // MARK: Outlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var payButton: SCButton!
    
    // MARK: Properties
    var interactor: PaymentBusinessLogic?
    var router: PaymentRouter?
    var booking: Booking!
    
    var delegate: PaymentViewDelegate?
    
    private var shouldPerformSegue = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainPatientRouter.kVisitRequestNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MainPatientRouter.kVisitRequestNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldPerformSegue = false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return shouldPerformSegue
    }
    
    // MARK: View customization
    
    fileprivate func setupView() {
        totalPriceLabel.text = "\(booking.visit.cost.total) SAR"
    }
    
    // MARK: - Private
    
    @objc private func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.patient == User.current, booking.status == .canceled {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Display Logic
    
    func displayPaymentProfileWith(profile: Payment.Details?) {
        shouldPerformSegue = true
        payButton.isUserInteractionEnabled = true
        performSegue(withIdentifier: "PaymentProfile", sender: profile)
    }
    
    func handle(error: Error) {
//        router?.showError(error)
        dismiss(animated: true, completion: nil)
    }
    func visitCancelled() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Event handling
    
    @IBAction func payAction(_ sender: Any) {
        interactor?.fetchPaymentProfile()
        payButton.isUserInteractionEnabled = false
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        interactor?.cancelVisitRequestFor(booking: booking)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    // MARK: Presenter methods
    
    
    
}
