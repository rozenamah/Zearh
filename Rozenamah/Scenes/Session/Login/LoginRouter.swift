import UIKit

class LoginRouter: Router, AlertRouter, AppStartRouter {
    typealias RoutingViewController = LoginViewController
    weak var viewController: LoginViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    // MARK: Passing data

}
