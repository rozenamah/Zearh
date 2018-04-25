import UIKit

class TransactionHistoryRouter: Router, AlertRouter {
    typealias RoutingViewController = TransactionHistoryViewController
    weak var viewController: TransactionHistoryViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transaction_detail_segue", let transaction = sender as? Transaction {
            passTransactionInfo(vc: segue.destination, transaction)
        }
    }

    // MARK: Navigation
    
    func navigateToTransactionDetail(for transaction: Transaction) {
        viewController?.performSegue(withIdentifier: "transaction_detail_segue", sender: transaction)
    }
    
    func dissmis() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data
    
    private func passTransactionInfo(vc: UIViewController, _ transaction: Transaction) {
        let detailVC = vc as? TransactionDetailViewController
        detailVC?.transactionDetail = transaction
    }

}
