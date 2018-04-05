import UIKit
import SwiftCake

protocol CallDoctorDisplayLogic: ClassificationDelegate, CallDoctorFiltersDelegate {
}

class CallDoctorViewController: UIViewController, CallDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var professionButton: SCButton!
    @IBOutlet weak var specializationButton: SCButton!
    
    // MARK: Properties
    var interactor: CallDoctorBusinessLogic?
    var router: CallDoctorRouter?
    
    /// Currently selected filters
    var callForm = CallDoctorForm()

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
        fillCurrentFilters()
    }
    
    fileprivate func fillCurrentFilters() {
        
        // Setup current filters
        if let classification = callForm.classification {
            classificationSelected(classification)
        } else {
            professionButton.isSelected = false
        }
        
        if let specialization = callForm.specialization {
            specializationSelected(specialization)
        } else {
            specializationButton.isSelected = false
            // Also - disable specialization if not a conultant or specialist
            if callForm.classification != .consultants, callForm.classification != .specialist {
                disableSpecialization()
            }
        }
//
//        if let minPrice = callFormToChange.minPrice {
//            priceSlider.selectedMinValue = CGFloat(minPrice)
//        } else {
//            priceSlider.selectedMinValue = 0
//        }
//        if let maxPrice = callFormToChange.maxPrice {
//            priceSlider.selectedMaxValue = CGFloat(maxPrice)
//        } else {
//            priceSlider.selectedMaxValue = 501
//        }
//        if let gender = callFormToChange.gender {
//            genderButtons.forEach { $0.isSelected = false }
//            switch gender {
//            case .female:
//                femaleButton.isSelected = true
//            case .male:
//                maleButton.isSelected = true
//            }
//        } else {
//            genderButtons.forEach { $0.isSelected = false }
//            allButton.isSelected = true
//        }
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
    
    func newFilters(inForm form: CallDoctorForm) {
        // New, updated forms
        callForm = form
        
        // Refresh view
        fillCurrentFilters()
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        callForm.classification = classification
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        specializationButton.isSelected = false
        
        // Enable specialization if needed
        if classification == .specialist || classification == .consultants {
            enableSpecialization()
        } else {
            callForm.specialization = nil
            disableSpecialization()
        }
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        callForm.specialization = specialization
        
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
