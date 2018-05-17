import UIKit

protocol TransactionDetailDisplayLogic: class {
}

class TransactionDetailViewController: UIViewController, TransactionDetailDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var rightAddressConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodTypeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var leaveTimeLabel: UILabel!
    @IBOutlet weak var rightDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    
    // MARK: Properties
    var interactor: TransactionDetailBusinessLogic?
    var router: TransactionDetailRouter?
    
    /// Visit which will be displayed in this screen
    var transactionDetail: Booking!

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
        // Adjust view for arabic language
        if self.view.isRTL() {
            // Add needed space in between address label and map icon
            rightAddressConstraint.constant = 16 + mapImage.bounds.width
            // Add needed space in between date label and map calendar icon
            rightDateConstraint.constant = 16 + calendarImage.bounds.width
            feeLabel.textAlignment = .right
        }
    }
    
    private func customizeUserDetails() {
        
//        let user = transactionDetail.user
//        let visit = transactionDetail.visit
//        nameLabel.text = user.fullname
//        specialistLabel.isHidden = user.doctor == nil
//        specialistLabel.text = user.doctor?.specialization?.title
////        addressLabel.text = visit.address
//        priceLabel.text = "\(visit.price) SAR"
//        feeLabel.isHidden = visit.fee == 0
//        feeLabel.text = "+ \(visit.fee) SAR for cancellation"
//        methodTypeLabel.text = transactionDetail.paymentMethod.title
//        arrivalTimeLabel.text = transactionDetail.arrivalTimestamp.dateToString(.hour)
//        leaveTimeLabel.text = transactionDetail.leaveTimestamp.dateToString(.hour)
//        dateLabel.text = transactionDetail.dateTimestamp.dateToString(.date)
        
        
    }

    // MARK: Event handling

    @IBAction func backAction(_ sender: Any) {
        router?.popViewController()
    }
    // MARK: Presenter methods
}
