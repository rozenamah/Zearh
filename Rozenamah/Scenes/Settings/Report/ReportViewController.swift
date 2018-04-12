import UIKit
import SwiftCake
import IQKeyboardManager

protocol ReportDisplayLogic: class {
    func handle(error: Error, inField field: ReportViewController.Field)
    func displayReportSentSuccessful()
}

class ReportViewController: UIViewController, ReportDisplayLogic {
    
    enum Field {
        case subject
        case field
        case unknown
    }

    // MARK: Outlets
    @IBOutlet weak var textView: SCTextViewWithPlaceholder!
    @IBOutlet weak var subjectButton: SCButton!
    @IBOutlet weak var messageView: RMTextFieldWithError!
    
    // MARK: Properties
    var interactor: ReportBusinessLogic?
    var router: ReportRouter?

    /// Report data which will be sent to API
    var reportForm = ReportForm()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // We disable IQKeyboard for this screen, because textView is is too big
        // and it causes that some views are out of the screen
        // when IQKeyboard scrolls it up
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }

    // MARK: View customization

    fileprivate func setupView() {
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
        textView.placeholder = "Your message"
    }

    // MARK: Event handling
    
    @IBAction func reportAction(_ sender: Any) {
        if interactor?.validate(reportForm) == true {
            interactor?.reportSubject(reportForm)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func subjectAction(_ sender: Any) {
        hideErrorIn(button: subjectButton)
        router?.navigateToSelectingSubject()
    }
    
    func subjectSelected(_ subject: ReportSubject) {
        reportForm.subject = subject
        
        subjectButton.setTitle(subject.title, for: .selected)
        subjectButton.isSelected = true
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        router?.dismiss()
    }
    
    // MARK: Presenter methods
    
    func handle(error: Error, inField field: ReportViewController.Field) {
        switch field {
        case .field:
            messageView.adjustToState(.error(msg: error))
        case .subject:
            displayErrorIn(button: subjectButton)
        case .unknown:
            router?.showError(error)
        }
    }
    
    func displayErrorIn(button: SCButton) {
        button.borderColor = .rmRed
        button.setTitleColor(.rmRed, for: .normal)
    }
    
    func hideErrorIn(button: SCButton) {
        button.borderColor = .rmPale
        button.setTitleColor(.rmGray, for: .normal)
    }
    
    func displayReportSentSuccessful() {
        router?.showAlert(message: "Report was sent", with: true)
    }
}

extension ReportViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView.placeholder = ""
        messageView.adjustToState(.active)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text == "" {
            self.textView.placeholder = "Your message"
        }
        messageView.adjustToState(.inactive)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reportForm.text = textView.text
    }
}
