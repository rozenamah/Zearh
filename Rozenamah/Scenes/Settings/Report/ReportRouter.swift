import UIKit

class ReportRouter: Router, AlertRouter {
    typealias RoutingViewController = ReportViewController
    weak var viewController: ReportViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showReportSent(sender:UIView) {
        let alert = UIAlertController(title: "settings.report.reportSent".localized, message: "settings.report.description".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { (_) in
            self.dismiss()
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func navigateToSelectingSubject(sender:UIView) {
        let alert = UIAlertController(title: "settings.report.alertTitle".localized, message: "settings.report.selectSubject".localized, preferredStyle: .actionSheet)
        ReportSubject.all.forEach { (subject) in
            alert.addAction(UIAlertAction(title: subject.title, style: .default, handler: { (action) in
                self.viewController?.subjectSelected(subject)
            }))
        }
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
