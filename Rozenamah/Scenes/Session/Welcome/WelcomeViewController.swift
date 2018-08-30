import UIKit

protocol WelcomeDisplayLogic: class {
}

class WelcomeViewController: UIViewController, WelcomeDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
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
        logoImageView.image = UIImage(named: "image.logo".localized)
    }

    // MARK: Event handling

    // MARK: Presenter methods
}
