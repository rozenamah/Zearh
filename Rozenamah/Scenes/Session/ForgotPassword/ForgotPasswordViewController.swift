import UIKit

protocol ForgotPasswordDisplayLogic: class {
    func handle(error: Error)
    func handle(error: Error, inField field: ForgotPasswordViewController.Field)
    func resetPasswordSuccess()
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordDisplayLogic {

    enum Field {
        case email
    }
    
    // MARK: Outlets
    @IBOutlet weak var emailView: RMTextFieldWithError!
    
    // MARK: Properties
    var interactor: ForgotPasswordBusinessLogic?
    var router: ForgotPasswordRouter?

    // Form used to perform reset password
    private var resetPasswordForm = ResetPasswordForm()
    
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
        // When app detects that is used with layout direction RTL, change textfield aligment to confrom arabic language
        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            emailView.textField.textAlignment = .right
        }
    }

    // MARK: Event handling

    @IBAction func resetPasswordAction(_ sender: Any) {
        // Check if reset form is valid - if so, proceed
        if interactor?.validate(resetForm: resetPasswordForm) == true {
            interactor?.resetPassword(withForm: resetPasswordForm)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hide keyboard
        view.endEditing(true)
    }
    
    // MARK: Presenter methods
    
    func resetPasswordSuccess() {
        router?.dismissAfterReset()
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: ForgotPasswordViewController.Field) {
        switch field {
        case .email:
            emailView.adjustToState(.error(msg: error))
        }
    }
}

// MARK: Input methods

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    @IBAction func textChanged(_ sender: UITextField) {
        resetPasswordForm.email = sender.text
        textFieldDidBeginEditing(sender) // To mark as active
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.active)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.inactive)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
