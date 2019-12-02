import UIKit

class ChangePasswordRouter: Router {
    typealias RoutingViewController = ChangePasswordViewController
    weak var viewController: ChangePasswordViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissAfterChangedPassword(sender:UIView) {
        let alert = UIAlertController(title: "generic.success".localized, message: "settings.changePassword.passwordChanged".localized, preferredStyle: .alert)
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
