import UIKit
import RangeSeekSlider

protocol CallDoctorFiltersDelegate: class {
    func newFilters(inForm form: CallDoctorForm)
}

protocol CallDoctorFiltersDisplayLogic: ClassificationDelegate, RangeSeekSliderDelegate {
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
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    // MARK: Properties
    var interactor: CallDoctorFiltersBusinessLogic?
    var router: CallDoctorFiltersRouter?
    
    /// Currently selected filters by user, bassed from previous screen
    var callForm: CallDoctorForm!
    
    /// When editing filters user is not saving it before clicking "Save",
    /// we store temporary selected filters here
    var callFormToChange: CallDoctorForm!
    
    weak var delegate: CallDoctorFiltersDelegate?

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
        // Copy currently selected filters to temporary, not saved filters
        callFormToChange = CallDoctorForm(formToCopy: callForm)
        
        // Specialization view is grayed out on start
        disableSpecialization()
        
        // Customize price slider
        priceSlider.maxLabelFont = UIFont.preferredFont(forTextStyle: .footnote)
        priceSlider.minLabelFont = UIFont.preferredFont(forTextStyle: .footnote)
        priceSlider.numberFormatter.positiveSuffix = " SAR"
        priceSlider.numberFormatter.zeroSymbol = "FREE"
        priceSlider.delegate = self
        
        fillCurrentFilters()
    }
    
    fileprivate func fillCurrentFilters() {
        
        // Setup current filters
        if let classification = callFormToChange.classification {
            classificationSelected(classification)
        } else {
            classificationButton.isSelected = false
        }
        
        if let specialization = callFormToChange.specialization {
            specializationSelected(specialization)
        } else {
            specializationButton.isSelected = false
            // Also - disable specialization if not a conultant or specialist
            if callFormToChange.classification != .consultants, callFormToChange.classification != .specialist {
                disableSpecialization()
            }
        }
        
        if let minPrice = callFormToChange.minPrice {
            priceSlider.selectedMinValue = CGFloat(minPrice)
        } else {
            priceSlider.selectedMinValue = 0
        }
        if let maxPrice = callFormToChange.maxPrice {
            priceSlider.selectedMaxValue = CGFloat(maxPrice)
        } else {
            priceSlider.selectedMaxValue = 501
        }
        
        // Price slider dosen't refresh automaticlly here,
        // we set new max value to perform forced refresh
        priceSlider.maxValue = 501
        
        if let gender = callFormToChange.gender {
            genderButtons.forEach { $0.isSelected = false }
            switch gender {
            case .female:
                femaleButton.isSelected = true
            case .male:
                maleButton.isSelected = true
            }
        } else {
            genderButtons.forEach { $0.isSelected = false }
            allButton.isSelected = true
        }
    }

    // MARK: Event handling

    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        // Create empty state
        callFormToChange = CallDoctorForm()
        
        // Refresh view
        fillCurrentFilters()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        delegate?.newFilters(inForm: callFormToChange)
        router?.dismiss()
    }
    
    @IBAction func changeGenderAction(_ sender: UIButton) {
        genderButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender {
        case maleButton:
            callFormToChange.gender = .male
        case femaleButton:
            callFormToChange.gender = .female
        default:
            callFormToChange.gender = nil
        }
    }
    
    @IBAction func professionChooseAction(_ sender: Any) {
        router?.navigateToSelectingClassification()
    }
    
    @IBAction func specializationChooseAction(_ sender: Any) {
        router?.navigateToSelectingSpecialization()
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        
        callFormToChange.classification = classification
        
        classificationButton.setTitle(classification.title, for: .selected)
        classificationButton.isSelected = true
        
        // Reset specialization
        specializationButton.isSelected = false
        
        // Enable specialization if needed
        if classification == .specialist || classification == .consultants {
            enableSpecialization()
        } else {
            callFormToChange.specialization = nil
            disableSpecialization()
        }
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        callFormToChange.specialization = specialization
        
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
    
    // MARK: Price range
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        if slider.selectedMaxValue > 500 {
            return "+∞"
        }
        return nil // Default will be applied
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        callFormToChange.minPrice = Int(minValue)
        callFormToChange.maxPrice = Int(maxValue)
    }
}