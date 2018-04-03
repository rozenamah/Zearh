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

    // MARK: Passing data

}
