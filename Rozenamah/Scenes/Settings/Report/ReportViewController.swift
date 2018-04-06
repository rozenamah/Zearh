import UIKit

protocol ReportDisplayLogic: class {
}

class ReportViewController: UIViewController, ReportDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: ReportBusinessLogic?
    var router: ReportRouter?

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func scrollViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        router?.dismiss()
    }
    // MARK: Presenter methods
}
