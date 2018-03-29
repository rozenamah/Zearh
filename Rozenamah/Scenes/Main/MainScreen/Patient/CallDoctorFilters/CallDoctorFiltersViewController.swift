import UIKit

protocol CallDoctorFiltersDisplayLogic: ClassificationDelegate {
}

class CallDoctorFiltersViewController: UIViewController, CallDoctorFiltersDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet weak var classificationButton: UIButton!
    @IBOutlet weak var specializationButton: UIButton!
    
    // MARK: Properties
    var interactor: CallDoctorFiltersBusinessLogic?
    var router: CallDoctorFiltersRouter?

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
        // Specialization view is grayed out on start
        disableSpecialization()
    }

    // MARK: Event handling

    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func clearAction(_ sender: Any) {
    }
    
    @IBAction func changeGenderAction(_ sender: UIButton) {
        genderButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    
    @IBAction func professionChooseAction(_ sender: Any) {
        router?.navigateToSelectingClassification()
    }
    
    @IBAction func specializationChooseAction(_ sender: Any) {
        router?.navigateToSelectingSpecialization()
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        
        classificationButton.setTitle(classification.title, for: .selected)
        classificationButton.isSelected = true
        
        // Reset specialization
        specializationButton.isSelected = false
        
        // Enable specialization if needed
        if classification == .specialist || classification == .consultants {
            enableSpecialization()
        } else {
            disableSpecialization()
        }
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        specializationButton.setTitle(specialization.title, for: .selected)
        specializationButton.isSelected = true
    }
    
    func disableSpecialization() {
        specializationView.isUserInteractionEnabled = false
        specializationView.alpha = 0.4
    }
    
    func enableSpecialization() {
        specializationView.isUserInteractionEnabled = true
        specializationView.alpha = 1
    }
}
