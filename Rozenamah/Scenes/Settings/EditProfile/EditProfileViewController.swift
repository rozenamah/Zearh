import UIKit
import SwiftCake

protocol EditProfileDisplayLogic: ClassificationDelegate {
}

class EditProfileViewController: UIViewController, EditProfileDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameView: RMTextFieldWithError!
    @IBOutlet weak var surnameView: RMTextFieldWithError!
    @IBOutlet weak var professionButton: SCButton!
    @IBOutlet weak var specializationButton: SCButton!
    @IBOutlet weak var specializationView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTextView: SCView!
    @IBOutlet weak var priceTextField: SCTextField!
    @IBOutlet weak var doctorView: UIView!
    
    // MARK: Properties
    var interactor: EditProfileBusinessLogic?
    var router: EditProfileRouter?
    
    /// Form used to perform edit of user, we create it by initializing with current user
    var editForm: EditProfileForm?

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
        if let user = User.current {
            nameView.textField.text = user.name
            surnameView.textField.text = user.surname
            avatarImageView.setAvatar(for: user)
            
            // If user is patient - hide doctor edit
            if user.type == .doctor {
                doctorView.isHidden = false
                
            } else {
                doctorView.isHidden = true
            }
            
            // Create edit form
            editForm = EditProfileForm(user: user)
        }
    }

    // MARK: Event handling

    @IBAction func saveChanges(_ sender: Any) {
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func profileChangeAction(_ sender: Any) {
        router?.navigateToSelectingImageSource(allowEditing: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
    }
    
    @IBAction func professionAction(_ sender: Any) {
        router?.navigateToSelectingClassification()
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
        hideErrorIn(button: specializationButton)
        router?.navigateToSelectingSpecialization()
    }
    
    @IBAction func priceChanged(_ sender: Any) {
        // Restore regular colors
        priceTextView.borderColor = .rmPale
        priceTextField.placeholderColor = .rmGray
        
//        if let text = sender.text, let price = Int(text) {
//            registerForm.price = price
//        } else {
//            registerForm.price = nil
//        }
    }
    
    func deleteConfirm() {
        // TODO
    }
    
    // MARK: Presenter methods
    
    func displaySelectedAvatar(image: UIImage) {
        avatarImageView.image = image
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmPale
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    
    func classificationSelected(_ classification: Classification) {
        
        editForm?.doctor?.classification = classification
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        editForm?.doctor?.specialization = nil
        specializationButton.isSelected = false
        
        // Enable specialization and price if needed
        if classification == .specialist || classification == .consultants {
            priceTextField.text = nil
            editForm?.doctor?.price = nil
            enableSpecialization()
        } else {
            
            // Set default rice
            if classification == .nurse {
                priceTextField.text = "150"
                editForm?.doctor?.price = 150
            } else if classification == .doctor {
                priceTextField.text = "250"
                editForm?.doctor?.price = 250
            }
            
            disableSpecialization()
        }
    }
    
    func specializationSelected(_ specialization: DoctorSpecialization) {
        editForm?.doctor?.specialization = specialization
        
        specializationButton.setTitle(specialization.title, for: .selected)
        specializationButton.isSelected = true
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

extension EditProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow only backspace and numbers
        if string.isEmpty || Int(string) != nil {
            return true
        }
        return false
        
    }
    
}

