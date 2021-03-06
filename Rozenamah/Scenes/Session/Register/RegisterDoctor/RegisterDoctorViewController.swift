import UIKit
import SwiftCake

protocol RegisterDoctorDisplayLogic: ClassificationDelegate {
    func registerSuccess()
    func updateSuccess()
    func handle(error: Error)
    func handle(error: Error, inField field: RegisterDoctorViewController.Field)
}

class RegisterDoctorViewController: UIViewController, RegisterDoctorDisplayLogic {

    enum RegisterType {
        case register // This screen is called in register
        case update // This screen is called when updating from patient
    }
    
    enum Field {
        case classification
        case specialization
        case price
        case gender
    }
    
    // MARK: Outlets
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var pdfUploadButton: UIButton!
    @IBOutlet weak var professionButton: SCButton!
    @IBOutlet weak var specializationButton: SCButton!
    @IBOutlet weak var genderButton: SCButton!
    @IBOutlet weak var priceTextField: SCTextField!
    @IBOutlet weak var uploadTitleLabel: UILabel!
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTextView: SCView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: Properties
    var interactor: RegisterDoctorBusinessLogic?
    var router: RegisterDoctorRouter?

    /// Form used to perform register of doctor, passed from step 1
    var registerForm: CreateDoctorForm!
    
    /// By this value we know if this screen was called in register flow or from drawer menu
    /// in order to change patient to doctor
    var registerType: RegisterType = .register
    
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
        // This icon is visible after user choose PDF file
        pdfImageView.isHidden = true
        
        // If type is update - add cancel button to navigation bar
        if registerType == .update {
            let cancelButton = UIBarButtonItem(title: "generic.cancel".localized, style: .plain, target: self, action: #selector(cancelAction(_:)))
            navigationItem.leftBarButtonItem = cancelButton
            
            // Title label and button should be different on update
            titleLabel.text = "session.doctor.updateTo".localized
            createButton.setTitle("session.doctor.update".localized, for: .normal)
    
            // Create update form, it contains only doctor info
            registerForm = UpdateDoctorForm()
        }
        if view.isRTL() {
            professionButton.contentHorizontalAlignment = .right
            specializationButton.contentHorizontalAlignment = .right
            priceTextField.textAlignment = .right
            genderButton.contentHorizontalAlignment = .right
        }
        // Specialization and price will be enabled if General Doctor - otherwise it is hardcoded
        disableSpecialization()
    }

    // MARK: Event handling

    @IBAction func cancelAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func tapAction(_ sender: Any) {
        // Called when scroll view clicked
        view.endEditing(true)
    }
    
    @IBAction func uploadPDFAction(_ sender: Any) {
        router?.navigateToImportFile()
    }
    
    @IBAction func professionAction(_ sender: Any) {
        hideErrorIn(button: professionButton)
        router?.navigateToSelectingClassification(sender: sender as! UIView)
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
        hideErrorIn(button: specializationButton)
        router?.navigateToSelectingSpecialization(sender: sender as! UIView)
    }
    
    @IBAction func genderAction(_ sender: Any) {
        hideErrorIn(button: genderButton)
        router?.showGenderSelection(sender: sender as! UIView)
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        // Restore regular colors
        priceTextView.borderColor = .rmPale
        priceTextField.placeholderColor = .rmGray
        
        if let text = sender.text, let price = Int(text) {
            registerForm.price = price
        } else {
            registerForm.price = nil
        }
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        if interactor?.validate(registerForm: registerForm) == true {
            if registerForm.pdf == nil {
                router?.showAlert(message: "session.doctor.license".localized, sender: sender as! UIView)
                return
            }
            router?.showWaitAlert()
            if registerType == .register {
                if view.isRTL() {
                    registerForm.language = "sa"
                } else {
                    registerForm.language = "en"
                }
                interactor?.register(withForm: registerForm)
            } else {
                interactor?.update(withForm: registerForm)
            }
        }
    }
    
    // MARK: Presenter methods
    
    func classificationSelected(_ classification: Classification) {
        
        registerForm.classification = classification
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        registerForm.specialization = nil
        specializationButton.isSelected = false
        
        // Hide error in specialization/price if any
        hideErrorIn(button: specializationButton)
        priceTextView.borderColor = .rmPale
        priceTextField.placeholderColor = .rmGray
        
        // Enable specialization and price if needed
        if classification == .specialist || classification == .consultants {
            priceTextField.text = nil
            registerForm.price = nil
            enableSpecialization()
        } else {
            
            // Set default rice
            if classification == .nurse {
                priceTextField.text = "150"
                registerForm.price = 150
            } else if classification == .doctor {
                priceTextField.text = "250"
                registerForm.price = 250
            }
            
            disableSpecialization()
        }
    }
    
    func genderSelected(_ gender: Gender) {
        registerForm.gender = gender
        
        genderButton.setTitle(gender.title, for: .selected)
        genderButton.isSelected = true
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        registerForm.specialization = specialization
        
        specializationButton.setTitle(specialization.title, for: .selected)
        specializationButton.isSelected = true
    }
    
    func pdfFileSelected(inData data: Data) {
        pdfImageView.isHidden = false
        pdfUploadButton.isSelected = true
        uploadTitleLabel.text = "session.doctor.document".localized
        
        registerForm.pdf = data
    }
    
    func handle(error: Error) {
        router?.hideWaitAlert(completion: {
            self.router?.showError(error, sender: self.view)
        })
    }
    
    func handle(error: Error, inField field: RegisterDoctorViewController.Field) {
        router?.hideWaitAlert()
        switch field {
        case .price:
            priceTextView.borderColor = .rmRed
            priceTextField.placeholderColor = .rmRed
        case .classification:
            displayErrorIn(button: professionButton)
        case .specialization:
            displayErrorIn(button: specializationButton)
        case .gender:
            displayErrorIn(button: genderButton)
        }
    }
    
    func registerSuccess() {
        router?.hideWaitAlert(completion: {
            self.router?.showDoctorCreatedAlert(withDismiss: false, sender: self.view)
        })
    }
    
    func updateSuccess() {
        router?.hideWaitAlert(completion: {
            self.router?.showDoctorCreatedAlert(withDismiss: true, sender: self.view)
        })
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmPale
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    /// Some classifications can't insert custom amount of money or specialization
    func disableSpecialization() {
        priceView.isUserInteractionEnabled = false
        priceView.alpha = 0.4
        specializationView.isUserInteractionEnabled = false
        specializationView.alpha = 0.4
    }
    
    func enableSpecialization() {
        priceView.isUserInteractionEnabled = true
        priceView.alpha = 1
        specializationView.isUserInteractionEnabled = true
        specializationView.alpha = 1
    }
}

// MARK: TextField methods

extension RegisterDoctorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow only backspace and numbers
        if string.isEmpty || Int(string) != nil {
            return true
        }
        return false
        
    }
    
}
