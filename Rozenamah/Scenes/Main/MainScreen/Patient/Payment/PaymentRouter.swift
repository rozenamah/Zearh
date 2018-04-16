import UIKit

class PaymentRouter: Router {
    typealias RoutingViewController = PaymentViewController
    weak var viewController: PaymentViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
