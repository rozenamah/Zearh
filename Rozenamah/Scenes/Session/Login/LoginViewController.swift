import UIKit

protocol LoginDisplayLogic: class {
    func handle(error: Error)
    func handle(error: Error, inField field: LoginViewController.Field)
    func loginSuccess()
}

class LoginViewController: UIViewController, LoginDisplayLogic {

    enum Field {
        case password
        case email
    }
    
    // MARK: Outlets
    @IBOutlet weak var emailView: RMTextFieldWithError!
    @IBOutlet weak var passwordView: RMTextFieldWithError!
    @IBOutlet weak var hidePasswordButton: UIButton!
    
    // MARK: Properties
    var interactor: LoginBusinessLogic?
    var router: LoginRouter?
    
    // Form used to perform login
    private var loginForm = LoginForm()

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
        
        // When app detects that is used with layout direction RTL, we change insets to adjust to current view
        if self.view.isRTL() {
            hidePasswordButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 30)
            emailView.textField.textAlignment = .right
        }
    }

    // MARK: Event handling
    
    @IBAction func loginAction(_ sender: Any) {
        // Check if login form is valid - if so, proceed
        if interactor?.validate(loginForm: loginForm) == true {
            interactor?.login(withForm: loginForm)
        }
    }
    
    @IBAction func hidePasswordAction(_ eyeButton: UIButton) {
        // Show/hide password letters
        eyeButton.isSelected = !eyeButton.isSelected
        passwordView.textField.isSecureTextEntry = !eyeButton.isSelected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hide keyboard
        view.endEditing(true)
    }
    
    // MARK: Presenter methods
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: LoginViewController.Field) {
        switch field {
        case .email:
            emailView.adjustToState(.error(msg: error))
        case .password:
            passwordView.adjustToState(.error(msg: error))
        }
    }
    
    func loginSuccess() {
        router?.navigateToDefaultApp()
    }
}

// MARK: Input methods

extension LoginViewController: UITextFieldDelegate {
    
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        loginForm.password = sender.text
        textFieldDidBeginEditing(sender) // To mark as active
    }
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        loginForm.email = sender.text
        textFieldDidBeginEditing(sender) // To mark as active
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.active)
        } else {
            passwordView.adjustToState(.active)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.inactive)
        } else {
            passwordView.adjustToState(.inactive)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailView.textField == textField {
            passwordView.textField.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
}
