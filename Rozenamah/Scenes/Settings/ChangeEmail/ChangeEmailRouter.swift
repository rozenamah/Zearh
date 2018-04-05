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
    
    func dismissAfterChangedEmail() {
        let alert = UIAlertController(title: "Success", message: "Your email has beed changed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.viewController?.dismiss(animated: true, completion: nil)
        }))
        viewController?.present(alert, animated: true, completion: nil)
        
    }

    // MARK: Passing data

}
