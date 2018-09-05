import UIKit
import SwiftCake

protocol RegisterPatientDisplayLogic: class {
    func handle(error: Error)
    func handle(error: Error, inField field: RegisterPatientViewController.Field)
    func registerSuccess()
    func continueToNextStep()
}

class RegisterPatientViewController: UIViewController, RegisterPatientDisplayLogic {

    enum Field {
        case password
        case email
        case surname
        case name
        case confirmPassword
        case phone
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
    @IBOutlet weak var phoneView: RMTextFieldWithError!
    @IBOutlet weak var checkboxButton: SCCheckbox!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet var textfieldCollection: [SCTextField]!
    
    // MARK: Properties
    var interactor: RegisterPatientBusinessLogic?
    var router: RegisterPatientRouter?

    /// Form used to perform register of patient
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
            titleLabel.text = "session.doctor.title".localized
            createAccountButton.setTitle("session.doctor.next".localized, for: .normal)
            
            // Update form to more advanced, doctor form
            registerForm = RegisterDoctorForm()
            
        }
         // Customize button insets depedning on layout direction
        if self.view.isRTL() {
            checkboxButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            checkboxButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: -16)
            termsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            checkboxButton.contentHorizontalAlignment = .right
            termsButton.contentHorizontalAlignment = .right
            // Set text input from right if arabic language
            textfieldCollection.forEach({ $0.textAlignment = .right })
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
                
                router?.showWaitAlert()
                if view.isRTL() {
                    registerForm.language = "sa"
                } else {
                    registerForm.language = "en"
                }
                if registrationMode == .doctor {
                    interactor?.checkIfEmailOrPhoneTaken(registerForm) 
                } else {
                    interactor?.register(withForm: registerForm)
                }
             } else {
                router?.showAlert(message: "session.patient.terms".localized)
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
        router?.hideWaitAlert {
            self.router?.showError(error)
        }
    }
    
    func handle(error: Error, inField field: RegisterPatientViewController.Field) {
        router?.hideWaitAlert()
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
        case .phone:
            phoneView.adjustToState(.error(msg: error))
        }
    }
    
    func continueToNextStep() {
        router?.hideWaitAlert(completion: {
            self.router?.navigateToDoctorStep2()
        })
    }
    
    func registerSuccess() {
        router?.hideWaitAlert(completion: {
            self.router?.navigateToApp(inModule: .patient)
        })
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
        case phoneView.textField:
            registerForm.phone = textField.text
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
        case phoneView.textField:
            phoneView.adjustToState(.active)
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
        case phoneView.textField:
            phoneView.adjustToState(.inactive)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailView.textField:
            phoneView.textField.becomeFirstResponder()
            return false
        case phoneView.textField:
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
