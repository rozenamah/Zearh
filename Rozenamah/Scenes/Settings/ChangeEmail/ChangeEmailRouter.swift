import UIKit

class ChangeEmailRouter: Router {
    typealias RoutingViewController = ChangeEmailViewController
    weak var viewController: ChangeEmailViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissAfterChangedEmail(sender:UIView) {
        let alert = UIAlertController(title: "generic.success".localized, message: "settings.changeEmail.emailChanged".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { [weak self] (action) in
            self?.viewController?.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
        
    }

    // MARK: Passing data

}
