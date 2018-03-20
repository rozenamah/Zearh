import UIKit
import KeychainAccess

protocol SplashDisplayLogic: class {
    func userCorrect()
    func tokenInvalid()
    func handle(error: Error)
}

class SplashViewController: UIViewController, SplashDisplayLogic {

    // MARK: Outlets

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
    
    func userCorrect() {
        router?.navigateToAppWithDelay()
    }
    
    func handle(error: Error) {
        router?.showError(error)
    }
}