import UIKit

protocol TransactionDetailDisplayLogic: class {
}

class TransactionDetailViewController: UIViewController, TransactionDetailDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var SARLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    // MARK: Properties
    var interactor: TransactionDetailBusinessLogic?
    var router: TransactionDetailRouter?

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
        customizeUserDetails()
    }
    
    private func customizeUserDetails() {
        if User.current?.type == .doctor {
            specialistLabel.isHidden = true
        }
    }

    // MARK: Event handling

    @IBAction func backAction(_ sender: Any) {
        router?.popViewController()
    }
    // MARK: Presenter methods
}