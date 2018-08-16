import UIKit

class PaymentRouter: Router {
    typealias RoutingViewController = PaymentViewController
    weak var viewController: PaymentViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
        identifier == "PaymentProfile", let destinationVC = segue.destination as? PaymentProfileViewController,
        var destinationDS = destinationVC.router?.dataStore else {
            print("Cannot initalize payment profile view controller")
            return
        }
        print("Route to payment profile")
    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
