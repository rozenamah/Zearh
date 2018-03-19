import UIKit

protocol RegisterDoctorDisplayLogic: class {
}

class RegisterDoctorViewController: UIViewController, RegisterDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var pdfImageView: UIImageView!
    @IBOutlet weak var pdfUploadButton: UIButton!
    
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
    }
    
    @IBAction func specializatioAction(_ sender: Any) {
    }
    
    @IBAction func genderAction(_ sender: Any) {
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
//        if interactor?.validate(registerForm: registerForm) == true {
//            interactor?.register(withForm: registerForm)
//        }
    }
    
    // MARK: Presenter methods
    
    func pdfFileSelected(inData data: Data) {
        pdfImageView.isHidden = false
        pdfUploadButton.isSelected = true
        
        registerForm.pdf = data
    }
}

extension RegisterDoctorViewController: UITextFieldDelegate {
    
}
