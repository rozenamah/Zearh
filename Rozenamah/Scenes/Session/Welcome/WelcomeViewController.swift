import UIKit
import Localize

protocol WelcomeDisplayLogic: class {
}

class WelcomeViewController: UIViewController, WelcomeDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var btnLanguage: UIButton!
    // MARK: Properties
    var interactor: WelcomeBusinessLogic?
    var router: WelcomeRouter?

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
        if Localize.shared.currentLanguage == "ar"  {
            btnLanguage.setTitle("English", for: .normal)
        } else {
            btnLanguage.setTitle("العربية", for: .normal)
        }
        logoImageView.image = UIImage(named: "image.logo".localized)
    }

    // MARK: Event handling

    @IBAction func btnLanguage_Tapped(_ sender: Any) {
        if Localize.shared.currentLanguage == "ar"  {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            Localize.shared.update(language: "en")
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            Localize.shared.update(language: "ar")
        }
        let storyboard = UIStoryboard(name: "Session", bundle: nil)
        guard let startVC = storyboard.instantiateInitialViewController(),
            let delegate = UIApplication.shared.delegate as? AppDelegate,
            let window = delegate.window
            else { return }
        window.rootViewController = startVC
    }
    // MARK: Presenter methods
}
