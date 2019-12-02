import UIKit

class TransactionHistoryRouter: Router, AlertRouter {
    typealias RoutingViewController = TransactionHistoryViewController
    weak var viewController: TransactionHistoryViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transaction_detail_segue", let booking = sender as? Booking {
            passTransactionInfo(vc: segue.destination, booking)
        }
    }

    // MARK: Navigation
    
    func navigateToTransactionDetail(for booking: Booking) {
        viewController?.performSegue(withIdentifier: "transaction_detail_segue", sender: booking)
    }
    
    func dissmis() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data
    
    private func passTransactionInfo(vc: UIViewController, _ booking: Booking) {
        let detailVC = vc as? TransactionDetailViewController
        detailVC?.booking = booking
        detailVC?.currentMode = viewController?.currentMode
    }

}
