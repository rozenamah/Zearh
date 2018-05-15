import UIKit
import SwiftCake

protocol CallDoctorDisplayLogic: ClassificationDelegate, CallDoctorFiltersDelegate {
    func handle(error: Error)
    func handle(error: Error, inField field: CallDoctorViewController.Field)
    func patientHasNoLocation()
}

class CallDoctorViewController: UIViewController, CallDoctorDisplayLogic {

    enum Field {
        case classification
        case specialization
    }
    
    // MARK: Outlets
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var professionButton: SCButton!
    @IBOutlet weak var specializationButton: SCButton!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var genderButton: SCButton!
    @IBOutlet weak var priceButton: SCButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    // MARK: Properties
    var interactor: CallDoctorBusinessLogic?
    var router: CallDoctorRouter?
    
    /// Currently selected filters
    var callForm = CallDoctorForm()
    
    /// We use it to communicate flow to main screen
    weak var flowDelegate: PatientFlowDelegate?

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
    
    private func fillCurrentFilters() {
        
        // We store specialization because classificationSelected will remove it so we temproray save it
        let selectedSpecialization = callForm.specialization
        
        // Setup current filters
        if let classification = callForm.classification {
            classificationSelected(classification)
        } else {
            professionButton.isSelected = false
        }
        
        if let specialization = selectedSpecialization {
            callForm.specialization = selectedSpecialization
            specializationSelected(specialization)
        } else {
            specializationButton.isSelected = false
            // Also - disable specialization if not a conultant or specialist
            if callForm.classification != .consultants, callForm.classification != .specialist {
                disableSpecialization()
            }
        }
        
        fillGenderAndPriceFilters()
    }
    
    private func fillGenderAndPriceFilters() {
    
        var shouldDisplayFilters = false
        if let minPrice = callForm.minPrice, let maxPrice = callForm.maxPrice {
            // Both prices set, show fitlers
            shouldDisplayFilters = true
            priceButton.setTitle("\(minPrice) - \(maxPrice) SAR", for: .normal)
            priceButton.isHidden = false
            
        } else if let minPrice = callForm.minPrice {
            // Only min price
            shouldDisplayFilters = true
            priceButton.setTitle("\(minPrice) - +∞ SAR", for: .normal)
            priceButton.isHidden = false
        } else if let maxPrice = callForm.maxPrice {
            // Only max price
            shouldDisplayFilters = true
            priceButton.setTitle("FREE - \(maxPrice) SAR", for: .normal)
            priceButton.isHidden = false
        } else {
            priceButton.isHidden = true
        }
        
        // Set gender
        if let gender = callForm.gender {
            shouldDisplayFilters = true
            genderButton.isHidden = false
            genderButton.setTitle(gender.title, for: .normal)
        } else {
            genderButton.isHidden = true
        }
        
        moreOptionsButton.isHidden = shouldDisplayFilters
        filterStackView.isHidden = !shouldDisplayFilters
    }
    
    func disableSpecialization() {
        specializationView.isUserInteractionEnabled = false
        specializationView.alpha = 0.4
    }
    
    func enableSpecialization() {
        specializationView.isUserInteractionEnabled = true
        specializationView.alpha = 1
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmPale
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    // MARK: Event handling

    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .pending)
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
    
    @IBAction func searchAction(_ sender: Any) {
        if interactor?.validate(form: callForm) == true {
            flowDelegate?.changeStateTo(flowPoint: .searchWith(filters: callForm))
        }
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        callForm.classification = classification
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        specializationButton.isSelected = false
        callForm.specialization = nil
        
        // Hide error in specialization if any
        hideErrorIn(button: specializationButton)
        
        // Enable specialization if needed
        if classification == .specialist || classification == .consultants {
            enableSpecialization()
        } else {
            callForm.specialization = nil
            disableSpecialization()
            fillGenderAndPriceFilters()
        }
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        callForm.specialization = specialization
        
        specializationButton.setTitle(specialization.title, for: .selected)
        specializationButton.isSelected = true
    }
    
    func patientHasNoLocation() {
        flowDelegate?.changeStateTo(flowPoint: .noLocation)
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: CallDoctorViewController.Field) {
        switch field {
        case .classification:
            displayErrorIn(button: professionButton)
        case .specialization:
            displayErrorIn(button: specializationButton)
        }
    }
    
}
