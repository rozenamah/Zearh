import UIKit

protocol RegisterDoctorDisplayLogic: class {
}

class RegisterDoctorViewController: UIViewController, RegisterDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var pdfUploadButton: UIButton!
    @IBOutlet weak var professionButton: UIButton!
    @IBOutlet weak var specializationButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var uploadTitleLabel: UILabel!
    
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
        pdfImageView.isHidden = false
        
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
        router?.showProfessionSelection()
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
        router?.showSpecializationSelection()
    }
    
    @IBAction func genderAction(_ sender: Any) {
        router?.showGenderSelection()
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        if let text = sender.text, let price = Int(text) {
            registerForm.price = price
        } else {
            registerForm.price = nil
        }
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
//        if interactor?.validate(registerForm: registerForm) == true {
//            interactor?.register(withForm: registerForm)
//        }
    }
    
    // MARK: Presenter methods
    
    func professionSelected(_ profession: Profession) {
        registerForm.profession = profession
        
        professionButton.setTitle(profession.rawValue, for: .selected)
        professionButton.isSelected = true
    }
    
    func genderSelected(_ gender: Gender) {
        registerForm.gender = gender
        
        genderButton.setTitle(gender.rawValue, for: .selected)
        genderButton.isSelected = true
    }
    
    func specializationSelected(_ specialization: String) {
        registerForm.specialization = specialization
        
        specializationButton.setTitle(specialization, for: .selected)
        specializationButton.isSelected = true
    }
    
    func pdfFileSelected(inData data: Data) {
        pdfImageView.isHidden = false
        pdfUploadButton.isSelected = true
        uploadTitleLabel.text = "Change your document"
        
        registerForm.pdf = data
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
