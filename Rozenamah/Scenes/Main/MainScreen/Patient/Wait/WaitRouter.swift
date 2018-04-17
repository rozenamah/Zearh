import UIKit

class WaitRouter: Router, AlertRouter {
    typealias RoutingViewController = WaitViewController
    weak var viewController: WaitViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    // MARK: Passing data

}
