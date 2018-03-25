import UIKit

protocol EditProfileDisplayLogic: class {
}

class EditProfileViewController: UIViewController, EditProfileDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameView: RMTextFieldWithError!
    @IBOutlet weak var surnameView: RMTextFieldWithError!
    
    // MARK: Properties
    var interactor: EditProfileBusinessLogic?
    var router: EditProfileRouter?

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
    
    // MARK: Presenter methods
    
    func displaySelectedAvatar(image: UIImage) {
        avatarImageView.image = image
    }
    
}
