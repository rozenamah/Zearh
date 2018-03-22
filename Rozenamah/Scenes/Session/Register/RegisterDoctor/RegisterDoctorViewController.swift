import UIKit
import SwiftCake

protocol RegisterDoctorDisplayLogic: class {
    func registerSuccess()
    func handle(error: Error)
    func handle(error: Error, inField field: RegisterDoctorViewController.Field)
}

class RegisterDoctorViewController: UIViewController, RegisterDoctorDisplayLogic {

    enum Field {
        case profession
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
    
    // MARK: Properties
    var interactor: RegisterDoctorBusinessLogic?
    var router: RegisterDoctorRouter?

    // Form used to perform register of doctor, passed from step 1
    var registerForm: RegisterDoctorForm!
    
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
        
        // Specialization and price will be enabled if General Doctor - otherwise it is hardcoded
        disableSpecialization()
    }

    // MARK: Event handling

    @IBAction func tapAction(_ sender: Any) {
        // Called when scroll view clicked
        view.endEditing(true)
    }
    
    @IBAction func uploadPDFAction(_ sender: Any) {
        router?.navigateToImportFile()
    }
    
    @IBAction func professionAction(_ sender: Any) {
        hideErrorIn(button: professionButton)
        router?.showProfessionSelection()
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
        hideErrorIn(button: specializationButton)
        router?.showSpecializationSelection()
    }
    
    @IBAction func genderAction(_ sender: Any) {
        hideErrorIn(button: genderButton)
        router?.showGenderSelection()
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        // Restore regular colors
        priceTextView.borderColor = .rmGray
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
                router?.showAlert(message: "You need to upload your doctor license")
            }
        }
    }
    
    // MARK: Presenter methods
    
    func professionSelected(_ profession: Profession) {
        registerForm.profession = profession
        
        professionButton.setTitle(profession.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        registerForm.specialization = nil
        specializationButton.isSelected = false
        
        // Enable specialization and price if needed
        if profession == .specialist || profession == .consultants {
            priceTextField.text = nil
            registerForm.price = nil
            enableSpecialization()
        } else {
            
            // Set default rice
            if profession == .nurse {
                priceTextField.text = "150"
                registerForm.price = 150
            } else if profession == .doctor {
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
        uploadTitleLabel.text = "Change your document"
        
        registerForm.pdf = data
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: RegisterDoctorViewController.Field) {
        switch field {
        case .price:
            priceTextView.borderColor = .rmRed
            priceTextField.placeholderColor = .rmRed
        case .profession:
            displayErrorIn(button: professionButton)
        case .specialization:
            displayErrorIn(button: specializationButton)
        case .gender:
            displayErrorIn(button: genderButton)
        }
    }
    
    func registerSuccess() {
        router?.navigateToApp()
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmGray
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    /// Some professions can't insert custom amount of money or specialization
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

extension RegisterDoctorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow only backspace and numbers
        if string.isEmpty || Int(string) != nil {
            return true
        }
        return false
        
    }
    
}
