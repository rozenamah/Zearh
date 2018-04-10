import UIKit

class TransactionDetailRouter: Router {
    typealias RoutingViewController = TransactionDetailViewController
    weak var viewController: TransactionDetailViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    // MARK: Passing data

}
