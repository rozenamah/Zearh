import UIKit

protocol PatientDetailsDisplayLogic: class {
}

class PatientDetailsViewController: UIViewController, PatientDetailsDisplayLogic {

    // MARK: Outlets
    
    @IBOutlet weak var priceAmountLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    // MARK: Properties
    var interactor: PatientDetailsBusinessLogic?
    var router: PatientDetailsRouter?
    
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
    }

    // MARK: Event handling
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    // MARK: Presenter methods
}
