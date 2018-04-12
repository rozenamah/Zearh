import UIKit

protocol AcceptDoctorDisplayLogic: class {
}

class AcceptDoctorViewController: UIViewController, AcceptDoctorDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: AcceptDoctorBusinessLogic?
    var router: AcceptDoctorRouter?

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

    // MARK: Presenter methods
}
