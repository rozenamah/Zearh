import UIKit

protocol LocationAlertDisplayLogic: class {
}

class LocationAlertViewController: UIViewController, LocationAlertDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: LocationAlertBusinessLogic?
    var router: LocationAlertRouter?

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
    }

    // MARK: Event handling

    @IBAction func settingsAction(_ sender: Any) {
    }
    
    // MARK: Presenter methods
}
