import UIKit

protocol EndVisitDisplayLogic: class {
    func handleError(_ error: Error)
    func visitEnded()
}

class EndVisitViewController: UIViewController, EndVisitDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var priceAmountLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var illnesView: UIView!
    @IBOutlet weak var medicineView: UIView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var cashReceivedCheckbox: UIButton!
    
    // MARK: Properties
    var interactor: EndVisitBusinessLogic?
    var router: EndVisitRouter?

    /// Information about patient and booking
    var booking: Booking!
    
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
        let visit = booking.visit
        let patient = booking.patient
        
        // TODO: Fill missing labels with correct data
        avatarImage.setAvatar(for: patient)
        nameLabel.text = patient.fullname
        priceAmountLabel.text = "\(visit.cost.price) SAR"
        feeAmountLabel.text = "\(visit.cost.fee) SAR"
        paymentMethodLabel.text = booking.payment.title
        
        // Hide view we don't use right now
        illnesView.isHidden = true
        medicineView.isHidden = true
        ageView.isHidden = true
        
        // If payment method is card - hide payment checkbox
        if booking.payment == .card {
            cashReceivedCheckbox.isHidden = true
        }
    }


    // MARK: Event handling
    @IBAction func checkBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func endVisitAction(_ sender: Any) {
        if booking.payment == .cash {
            if interactor?.validate(cashReceived: cashReceivedCheckbox.isSelected) == true {
                interactor?.end(booking: booking)
            }
        } else {
            interactor?.end(booking: booking)
        }
    }
    
    // MARK: Presenter methods
    
    func handleError(_ error: Error) {
        router?.showError(error)
    }
    
    func visitEnded() {
        // TODO: Navigate to transactions?
        router?.dismiss()
    }
}
