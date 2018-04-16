import UIKit

protocol PaymentDisplayLogic: class {
}

class PaymentViewController: UIViewController, PaymentDisplayLogic {

    // MARK: Outlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    
    // MARK: Properties
    var interactor: PaymentBusinessLogic?
    var router: PaymentRouter?

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

    @IBAction func payAction(_ sender: Any) {
        // TODO
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    // MARK: Presenter methods
}
