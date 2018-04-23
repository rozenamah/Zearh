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
    
    var visitDetails: VisitDetails!

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
        // TODO: Fill missing labels with correct data
        avatarImage.setAvatar(for: visitDetails.user)
        nameLabel.text = visitDetails.user.fullname
        priceAmountLabel.text = "\(visitDetails.visit.price) SAR"
        feeAmountLabel.text = "\(visitDetails.visit.fee) SAR"
    }

    // MARK: Event handling
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    // MARK: Presenter methods
}
