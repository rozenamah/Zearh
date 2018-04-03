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

    // MARK: Passing data

}
