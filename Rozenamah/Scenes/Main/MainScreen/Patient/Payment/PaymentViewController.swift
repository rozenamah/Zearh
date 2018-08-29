import UIKit
import SwiftCake

protocol PaymentDisplayLogic: class {
    func displayPaymentProfileWith(profile: Payment.Details?)
}

class PaymentViewController: UIViewController, PaymentDisplayLogic {
    
    // MARK: Outlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var payButton: SCButton!
    
    
    // MARK: Properties
    var interactor: PaymentBusinessLogic?
    var router: PaymentRouter?
    
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
    }
    
    // MARK: - Display Logic
    
    func displayPaymentProfileWith(profile: Payment.Details?) {
        shouldPerformSegue = true
        payButton.isUserInteractionEnabled = true
        performSegue(withIdentifier: "PaymentProfile", sender: profile)
    }
    
    // MARK: Event handling
    
    @IBAction func payAction(_ sender: Any) {
        interactor?.fetchPaymentProfile()
        payButton.isUserInteractionEnabled = false
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    // MARK: Presenter methods
}
