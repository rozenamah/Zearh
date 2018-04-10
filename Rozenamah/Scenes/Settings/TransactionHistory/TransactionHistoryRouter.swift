import UIKit

class TransactionHistoryRouter: Router {
    typealias RoutingViewController = TransactionHistoryViewController
    weak var viewController: TransactionHistoryViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func navigateToTransactionDetail() {
        viewController?.performSegue(withIdentifier: "transaction_detail_segue", sender: nil)
    }
    
    func dissmis() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
