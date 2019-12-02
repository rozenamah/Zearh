import UIKit

protocol ChangeEmailDisplayLogic: class {
    func displayError(_ error: Error)
    func emailChangedSuccessful()
}

class ChangeEmailViewController: UIViewController, ChangeEmailDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var emailView: RMTextFieldWithError!
    
    // MARK: Properties
    var interactor: ChangeEmailBusinessLogic?
    var router: ChangeEmailRouter?

    /// Form for which we send change email request
    private let emailForm = EmailForm()
    
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
        // If arabic language change aligment
        if self.view.isRTL() {
            emailView.textField.textAlignment = .right
        }
    }

    // MARK: Event handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func dismissAction(_ sender: Any) {
        view.endEditing(true)
        router?.dismiss()
    }
    
    @IBAction func changeEmailAction(_ sender: Any) {
        emailForm.email = emailView.textField.text
        if interactor?.validate(emailForm) == true {
            interactor?.changeEmail(emailForm)
        }
    }
    
    // MARK: Presenter methods
    
    func displayError(_ error: Error) {
        emailView.adjustToState(.error(msg: error))
    }
    
    func emailChangedSuccessful() {
        router?.dismissAfterChangedEmail(sender: self.view)
    }
}

extension ChangeEmailViewController: UITextFieldDelegate {
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        textFieldDidBeginEditing(sender)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.inactive)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if emailView.textField == textField {
            emailView.adjustToState(.active)
        }
    }
}
