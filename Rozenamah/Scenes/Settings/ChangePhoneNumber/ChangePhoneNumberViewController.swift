import UIKit

protocol ChangePhoneNumberDisplayLogic: class {
    func displayError(_ error: Error)
    func phoneNumberChangedSuccessful()
}

class ChangePhoneNumberViewController: UIViewController, ChangePhoneNumberDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var phoneNumberView: RMTextFieldWithError!
    
    // MARK: Properties
    var interactor: ChangePhoneNumberBusinessLogic?
    var router: ChangePhoneNumberRouter?
    
    /// Form for which we send change phone number request
    private let numberForm = PhoneNumberForm()

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
    
    @IBAction func changePhoneNumberAction(_ sender: Any) {
        numberForm.phoneNumber = phoneNumberView.textField.text
        if interactor?.validatePhoneNumber(numberForm) == true {
            interactor?.changePhoneNumber(numberForm)
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        view.endEditing(true)
        router?.dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Presenter methods
    
    func displayError(_ error: Error) {
        phoneNumberView.adjustToState(.error(msg: error))
    }
    
    func phoneNumberChangedSuccessful() {
        router?.dismissAfterChangedNumber()
    }
}

extension ChangePhoneNumberViewController: UITextFieldDelegate {
    
    @IBAction func numberChanged(_ sender: UITextField) {
        textFieldDidBeginEditing(sender)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if phoneNumberView.textField == textField {
            phoneNumberView.adjustToState(.inactive)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if phoneNumberView.textField == textField {
            phoneNumberView.adjustToState(.active)
        }
    }

}
