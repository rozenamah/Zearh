import UIKit
import SwiftCake

protocol CallDoctorDisplayLogic: ClassificationDelegate {
}

class CallDoctorViewController: UIViewController, CallDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var professionButton: SCButton!
    @IBOutlet weak var specializationButton: SCButton!
    
    // MARK: Properties
    var interactor: CallDoctorBusinessLogic?
    var router: CallDoctorRouter?

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

    @IBAction func cancelAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func professionChooseAction(_ sender: Any) {
        router?.navigateToSelectingClassification()
    }
    
    @IBAction func specializationChooseAction(_ sender: Any) {
        router?.navigateToSelectingSpecialization()
    }
    
    @IBAction func moreOptions(_ sender: Any) {
        router?.navigateToExtendedFilters()
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
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
