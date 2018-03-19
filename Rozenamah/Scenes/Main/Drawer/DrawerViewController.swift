import UIKit

protocol DrawerDisplayLogic: class {
    func logoutSuccess()
}

class DrawerViewController: UIViewController, DrawerDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: Properties
    var interactor: DrawerBusinessLogic?
    var router: DrawerRouter?

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
            
            nameLabel.text = user.fullname
            emailLabel.text = user.email
            
        }
        
    }

    // MARK: Event handling

    @IBAction func logoutAction(_ sender: Any) {
        router?.showLogoutAlert()
    }
    
    /// Called from confirmation alert
    func loginCofirmed() {
        interactor?.logout()
    }
    
    // MARK: Presenter methods
    
    
    func logoutSuccess() {
        router?.navigateToSignUp()
    }
}
