import UIKit

class PaymentMethodRouter: Router {
    typealias RoutingViewController = PaymentMethodViewController
    weak var viewController: PaymentMethodViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
