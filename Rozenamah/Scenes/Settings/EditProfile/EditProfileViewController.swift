import UIKit
import SwiftCake

protocol EditProfileDisplayLogic: ClassificationDelegate {
    func profileUpdatedSuccessful()
    func handle(error: Error, inField field: EditProfileViewController.Field)
    func handle(error: Error)
}

class EditProfileViewController: UIViewController, EditProfileDisplayLogic {
    
    enum Field {
        case name
        case surname
        case classification
        case specialization
        case price
    }

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
    @IBOutlet weak var professionView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var buttonCollection: [SCButton]!
    
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
            
            editForm = EditProfileForm(user: user)
            
            // If user is patient - hide doctor edit
            if user.type == .doctor {
                doctorView.isHidden = false
                filCurrentFilters(for: editForm)
            } else {
                doctorView.isHidden = true
            }
            
            if self.view.isRTL() {
                // Set aligment to right if RTL language
                buttonCollection.forEach({ $0.contentHorizontalAlignment = .right })
            }
        }
    }
    
    fileprivate func filCurrentFilters(for editForm: EditProfileForm?) {
        if let doctor = editForm?.doctor {
            professionButton.setTitle(doctor.classification.title, for: .selected)
            professionButton.isSelected = true
            if let specialization = doctor.specialization {
                specializationSelected(specialization)
            }

            if let price = doctor.price {
                priceTextField.text = "\(price)"
            }
        }
    }

    // MARK: Event handling
    
    @IBAction func scrollViewTapped(_ sender: Any) {
        // Hide keyboard when view clicked
        view.endEditing(true)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        editForm?.name = nameView.textField.text!
        editForm?.surname = surnameView.textField.text!
        if let editForm = editForm, interactor?.validate(editForm) == true {
            interactor?.updateUserInfo(editForm)
            
            // Block button until success/failure
            saveButton.isUserInteractionEnabled = false
        }
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
        hideErrorIn(button: professionButton)
        router?.navigateToSelectingClassification()
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
        hideErrorIn(button: specializationButton)
        router?.navigateToSelectingSpecialization()
    }
    
    @IBAction func priceChanged(_ sender: SCTextField) {
        // Restore regular colors
        priceTextView.borderColor = .rmPale
        priceTextField.placeholderColor = .rmGray
        
        if let text = sender.text, let price = Int(text) {
            editForm?.doctor?.price = price
        } else {
            editForm?.doctor?.price = nil
        }
    }
    
    func deleteConfirm() {
        // TODO
    }
    
    // MARK: Presenter methods
    
    func profileUpdatedSuccessful() {
        guard let user = User.current else {
            return
        }
        // Unblock button
        saveButton.isUserInteractionEnabled = true
        
        nameView.textField.text = user.name
        surnameView.textField.text = user.surname
        
        router?.showSuccessChangeAlert()
    }
    
    func handle(error: Error) {
        // Unblock button
        saveButton.isUserInteractionEnabled = true
        
        router?.showError(error)
    }
    
    func handle(error: Error, inField field: EditProfileViewController.Field) {
        // Unblock button
        saveButton.isUserInteractionEnabled = true
        
        switch field {
        case .name:
            nameView.adjustToState(.error(msg: error))
        case .surname:
            surnameView.adjustToState(.error(msg: error))
        case .classification:
            displayErrorIn(button: professionButton)
        case .specialization:
            displayErrorIn(button: specializationButton)
        case .price:
            priceTextView.borderColor = .rmRed
            priceTextField.placeholderColor = .rmRed
        }
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmPale
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    func displaySelectedAvatar(image: UIImage) {
        avatarImageView.image = image
        editForm?.avatar = image
        if let editForm = editForm {
            interactor?.updateUserAvatar(editForm)
        }
    }
    
    func classificationSelected(_ classification: Classification) {
        
        editForm?.doctor?.classification = classification
        
        professionButton.setTitle(classification.title, for: .selected)
        professionButton.isSelected = true
        
        // Reset specialization
        editForm?.doctor?.specialization = nil
        specializationButton.isSelected = false
        
        // Hide error in specialization/pric if any
        hideErrorIn(button: specializationButton)
        priceTextView.borderColor = .rmPale
        priceTextField.placeholderColor = .rmGray
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameView.textField:
            nameView.adjustToState(.active)
        case surnameView.textField:
            surnameView.adjustToState(.active)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameView.textField:
            nameView.adjustToState(.inactive)
        case surnameView.textField:
            surnameView.adjustToState(.inactive)
        default:
            break
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        switch sender {
        case nameView.textField:
            editForm?.name = sender.text!
        case surnameView.textField:
            editForm?.surname = sender.text!
        default:
            break
        }
        textFieldDidBeginEditing(sender)
    }
    
    
    
}

