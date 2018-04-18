import UIKit

class PaymentMethodRouter: Router, AlertRouter {
    typealias RoutingViewController = PaymentMethodViewController
    weak var viewController: PaymentMethodViewController?

    /// Alert view, displayed when accepting doctor
    private var alertLoading: UIAlertController?
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func showWaitAlert() {
        alertLoading = showLoadingAlert()
    }
    
    func hideWaitAlert(completion: (() -> Void)? = nil) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
    
    // MARK: Passing data

}
