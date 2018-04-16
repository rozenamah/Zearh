import UIKit

protocol PatientDetailsDisplayLogic: class {
}

class PatientDetailsViewController: UIViewController, PatientDetailsDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: PatientDetailsBusinessLogic?
    var router: PatientDetailsRouter?

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
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
    }
    
    // MARK: Presenter methods
}
