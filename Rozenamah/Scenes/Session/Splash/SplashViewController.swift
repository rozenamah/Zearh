import UIKit
import KeychainAccess

protocol SplashDisplayLogic: class {
    func userCorrect()
    func tokenInvalid()
    func blockedUser()
    func handle(error: Error)
}

class SplashViewController: UIViewController, SplashDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: Properties
    var interactor: SplashBusinessLogic?
    var router: SplashRouter?

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
        logoImageView.image = UIImage(named: "image.logo".localized)
        
        // Check if token exists - if so start main screen
        if let _ = Keychain.shared.token {
            interactor?.fetchUserData()
        } else {
            router?.navigateToSignUpWithDelay()
        }
    }

    // MARK: Event handling

    // MARK: Presenter methods
    
    func tokenInvalid() {
        router?.navigateToSignUp()
    }
    
    func blockedUser() {
        router?.showUserBlocked()
    }
    
    func userCorrect() {
        router?.navigateToAppWithDelay()
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
}
