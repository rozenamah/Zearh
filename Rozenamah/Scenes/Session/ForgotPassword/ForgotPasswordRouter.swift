import UIKit

class ForgotPasswordRouter: Router, AlertRouter {
    typealias RoutingViewController = ForgotPasswordViewController
    weak var viewController: ForgotPasswordViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismissAfterReset() {
        let alert = UIAlertController(title: "Success", message: "You should receive reset link on your email", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }))
        viewController?.present(alert, animated: true, completion: nil)
        
    }

    // MARK: Passing data

}
