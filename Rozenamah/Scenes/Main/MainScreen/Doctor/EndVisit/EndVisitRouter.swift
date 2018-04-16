import UIKit

class EndVisitRouter: Router {
    typealias RoutingViewController = EndVisitViewController
    weak var viewController: EndVisitViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    // MARK: Passing data

}
