import UIKit

protocol ChangePasswordDisplayLogic: class {
    func handle(error: Error, inField field: ChangePasswordViewController.Field)
    func passwordChangedSuccessful()
}

class ChangePasswordViewController: UIViewController, ChangePasswordDisplayLogic {
    
    enum Field {
        case currentPassword
        case newPassword
        case confirmPassword
    }

    // MARK: Outlets
    
    @IBOutlet weak var currentPasswordView: RMTextFieldWithError!
    @IBOutlet weak var newPasswordView: RMTextFieldWithError!
    @IBOutlet weak var confirmPasswordView: RMTextFieldWithError!
    
    // MARK: Properties
    
    var interactor: ChangePasswordBusinessLogic?
    var router: ChangePasswordRouter?
    
    var changePasswordForm = ChangePasswordForm()

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
    }

    // MARK: Event handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func dismissAction(_ sender: Any) {
        view.endEditing(true)
        router?.dismiss()
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        changePasswordForm.currentPassword = currentPasswordView.textField.text
        changePasswordForm.newPassword = newPasswordView.textField.text
        changePasswordForm.confirmPassword = confirmPasswordView.textField.text
        
        if interactor?.validate(changePasswordForm) == true {
            interactor?.changePassword(changePasswordForm)
        }
    }

    // MARK: Presenter methods
    
    func handle(error: Error, inField field: ChangePasswordViewController.Field) {
        switch field {
        case .currentPassword:
           currentPasswordView.adjustToState(.error(msg: error))
        case .newPassword:
           newPasswordView.adjustToState(.error(msg: error))
        case .confirmPassword:
            confirmPasswordView.adjustToState(.error(msg: error))
        }
    }
    
    func passwordChangedSuccessful() {
        router?.dismissAfterChangedPassword()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    @IBAction func currentPasswordTextChanged(_ sender: UITextField) {
        textFieldDidBeginEditing(sender)
    }
    
    @IBAction func newPasswordTextChanged(_ sender: UITextField) {
        textFieldDidBeginEditing(sender)
    }
    
    @IBAction func confirmPasswordTextChanged(_ sender: UITextField) {
        textFieldDidBeginEditing(sender)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case currentPasswordView.textField:
            currentPasswordView.adjustToState(.inactive)
        case newPasswordView.textField:
            newPasswordView.adjustToState(.inactive)
        case confirmPasswordView.textField:
            confirmPasswordView.adjustToState(.inactive)
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case currentPasswordView.textField:
            currentPasswordView.adjustToState(.active)
        case newPasswordView.textField:
            newPasswordView.adjustToState(.active)
        case confirmPasswordView.textField:
            confirmPasswordView.adjustToState(.active)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentPasswordView.textField:
            newPasswordView.textField.becomeFirstResponder()
            return false
        case newPasswordView.textField:
            confirmPasswordView.textField.becomeFirstResponder()
            return false
        case confirmPasswordView.textField:
            currentPasswordView.textField.becomeFirstResponder()
            return false
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
