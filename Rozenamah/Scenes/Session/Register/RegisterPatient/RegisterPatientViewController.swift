import UIKit
import SwiftCake

protocol RegisterPatientDisplayLogic: class {
    func handle(error: Error)
    func handle(error: Error, inField field: RegisterPatientViewController.Field)
    func registerSuccess()
}

class RegisterPatientViewController: UIViewController, RegisterPatientDisplayLogic {

    enum Field {
        case password
        case email
        case surname
        case name
        case confirmPassword
    }
    
    // MARK: Outlets
    @IBOutlet weak var termsAndConditionsCheckbox: SCCheckbox!
    @IBOutlet weak var nameView: RMTextFieldWithError!
    @IBOutlet weak var surnameView: RMTextFieldWithError!
    @IBOutlet weak var passwordView: RMTextFieldWithError!
    @IBOutlet weak var confirmPasswordView: RMTextFieldWithError!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailView: RMTextFieldWithError!
    @IBOutlet weak var createAccountButton: SCButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    var interactor: RegisterPatientBusinessLogic?
    var router: RegisterPatientRouter?

    // Form used to perform register of patient
    var registerForm = RegisterForm()
    
    /// Depending on this value we change behaviour of this view to register patient
    /// or move user to next screen (doctor registration).
    /// Default to patient
    var registrationMode: RegisterMode = .patient
    
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
        if registrationMode == .doctor {
            titleLabel.text = "Register as doctor"
            createAccountButton.setTitle("Next", for: .normal)
            
            // Update form to more advanced, doctor form
            registerForm = RegisterDoctorForm()
            
        }
    }

    // MARK: Event handling

    
    @IBAction func tapAction(_ sender: Any) {
        // Called when scroll view clicked
        view.endEditing(true)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        // Check if register form is valid and T&C accepted - if so, proceed
        if interactor?.validate(registerForm: registerForm) == true {
             if termsAndConditionsCheckbox.isSelected {
                
                if registrationMode == .doctor {
                    router?.navigateToDoctorStep2()
                } else {
                    interactor?.register(withForm: registerForm)
                }
             } else {
                router?.showAlert(message: "You need to accept Terms & Conditions")
            }
        }
    }
    
    @IBAction func changeProfileImageAction(_ sender: Any) {
        router?.navigateToSelectingImageSource(allowEditing: true)
    }
    
    // MARK: Presenter methods
    
    func displaySelectedAvatar(image: UIImage) {
        registerForm.avatar = image
        avatarImageView.image = image
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: RegisterPatientViewController.Field) {
        switch field {
        case .email:
            emailView.adjustToState(.error(msg: error))
        case .password:
            passwordView.adjustToState(.error(msg: error))
        case .name:
            nameView.adjustToState(.error(msg: error))
        case .surname:
            surnameView.adjustToState(.error(msg: error))
        case .confirmPassword:
            confirmPasswordView.adjustToState(.error(msg: error))
        }
    }
    
    func registerSuccess() {
        router?.navigateToApp()
    }
}

extension RegisterPatientViewController: UITextFieldDelegate {
    
    @IBAction func textChanged(_ textField: UITextField) {
        switch textField {
        case emailView.textField:
            registerForm.email = textField.text
        case passwordView.textField:
            registerForm.password = textField.text
        case nameView.textField:
            registerForm.name = textField.text
        case surnameView.textField:
            registerForm.surname = textField.text
        case confirmPasswordView.textField:
            registerForm.repeatPassword = textField.text
        default:
            break
        }
        textFieldDidBeginEditing(textField) // To mark as active
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailView.textField:
            emailView.adjustToState(.active)
        case passwordView.textField:
            passwordView.adjustToState(.active)
        case nameView.textField:
            nameView.adjustToState(.active)
        case surnameView.textField:
            surnameView.adjustToState(.active)
        case confirmPasswordView.textField:
            confirmPasswordView.adjustToState(.active)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailView.textField:
            emailView.adjustToState(.inactive)
        case passwordView.textField:
            passwordView.adjustToState(.inactive)
        case nameView.textField:
            nameView.adjustToState(.inactive)
        case surnameView.textField:
            surnameView.adjustToState(.inactive)
        case confirmPasswordView.textField:
            confirmPasswordView.adjustToState(.inactive)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailView.textField:
            passwordView.textField.becomeFirstResponder()
            return false
        case passwordView.textField:
            confirmPasswordView.textField.becomeFirstResponder()
            return false
        case nameView.textField:
            surnameView.textField.becomeFirstResponder()
            return false
        case surnameView.textField:
            emailView.textField.becomeFirstResponder()
            return false
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    
    
    
}
