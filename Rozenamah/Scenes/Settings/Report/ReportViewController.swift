import UIKit
import SwiftCake

protocol ReportDisplayLogic: class {
}

class ReportViewController: UIViewController, ReportDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var textView: SCGrowingTextView!
    @IBOutlet weak var subjectButton: SCButton!
    
    // MARK: Properties
    var interactor: ReportBusinessLogic?
    var router: ReportRouter?

    var reportForm: ReportForm?
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
        reportForm = ReportForm()
        setupView()
    }

    // MARK: View customization

    fileprivate func setupView() {
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
        
    }

    // MARK: Event handling
    
    @IBAction func reportAction(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func subjectAction(_ sender: Any) {
        router?.navigateToSelectingSubject()
    }
    
    func subjectSelected(_ subject: ReportSubject) {
        reportForm?.subject = subject
        
        subjectButton.setTitle(specialization.title, for: .selected)
        subjectButton.isSelected = true
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        router?.dismiss()
    }
    // MARK: Presenter methods
}

