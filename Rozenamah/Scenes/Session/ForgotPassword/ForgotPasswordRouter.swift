import UIKit

class ForgotPasswordRouter: Router, AlertRouter {
    typealias RoutingViewController = ForgotPasswordViewController
    weak var viewController: ForgotPasswordViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismissAfterReset() {
        let alert = UIAlertController(title: "generic.success".localized, message: "session.forgotPassword.resetLink".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { [weak self] (action) in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }))
        viewController?.present(alert, animated: true, completion: nil)
        
    }

    // MARK: Passing data

}
