import UIKit

protocol PaymentMethodDisplayLogic: class {
}

protocol PaymentMethodDelegate: class {
    func patientPayWith(_ type: PaymentMethod)
}

class PaymentMethodViewController: UIViewController, PaymentMethodDisplayLogic {

    // MARK: Outlets

    @IBOutlet weak var visitPriceLabel: UILabel!
    @IBOutlet weak var feePriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet var paymentMethodsButtons: [UIButton]!
    @IBOutlet weak var byCardButton: UIButton!
    @IBOutlet weak var byCashButton: UIButton!
    
    // MARK: Properties
    var interactor: PaymentMethodBusinessLogic?
    var router: PaymentMethodRouter?

    weak var delegate: PaymentMethodDelegate?
    var paymentMethod: PaymentMethod?
    
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
        paymentMethodsButtons.forEach({ $0.isSelected = false })
    }

    // MARK: Event handling
    
    @IBAction func paymentMethodAction(_ sender: UIButton) {
        paymentMethodsButtons.forEach({ $0.isSelected = false })
        if sender == byCardButton {
            byCardButton.isSelected = true
            paymentMethod = .card
        } else {
            byCashButton.isSelected = true
            paymentMethod = .cash
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if let paymentMethod = paymentMethod {
            delegate?.patientPayWith(paymentMethod)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    // MARK: Presenter methods
}
