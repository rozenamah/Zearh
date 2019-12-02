import UIKit

class PaymentRouter: Router, AlertRouter {
    typealias RoutingViewController = PaymentViewController
    weak var viewController: PaymentViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let identifier = segue.identifier,
//        identifier == "PaymentProfile", let destinationVC = segue.destination as? PaymentProfileViewController,
//        var destinationDS = destinationVC.router?.dataStore, let paymentProfile = sender as? Payment.Details else {
//            print("Cannot initalize payment profile view controller")
//            return
//        }
        if segue.identifier == "PaymentProfile" {
            let destinationVC = segue.destination as! PaymentProfileViewController
            var destinationDS = destinationVC.router?.dataStore
            destinationDS?.paymentProfile = sender as? Payment.Details
            destinationVC.delegate = self
            destinationVC.booking = viewController?.booking //Added By Hassan Bhatti
            print("Route to payment profile")
        }
    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
extension PaymentRouter: PaymentProfileDelegate {
    func paymentSuccess() {
        viewController?.delegate?.onPaymentDone()
    }
}
