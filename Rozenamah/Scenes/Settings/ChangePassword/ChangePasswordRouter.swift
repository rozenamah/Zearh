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
    
    func dismissAfterChangedPassword() {
        let alert = UIAlertController(title: "Success", message: "Your password has beed changed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.viewController?.dismiss(animated: true, completion: nil)
        }))
        viewController?.present(alert, animated: true, completion: nil)
        
    }

    // MARK: Passing data

}
