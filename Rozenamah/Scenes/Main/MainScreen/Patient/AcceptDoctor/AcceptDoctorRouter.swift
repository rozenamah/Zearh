import UIKit

class AcceptDoctorRouter: Router, PhoneCallRouter {
    typealias RoutingViewController = AcceptDoctorViewController
    weak var viewController: AcceptDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment_method_segue" {
            assignDelegate(segue.destination)
        }

    }

    // MARK: Navigation
    
    func navigateToPaymentMethod() {
        viewController?.performSegue(withIdentifier: "payment_method_segue", sender: nil)
    }

    // MARK: Passing data
    
    private func assignDelegate(_ vc: UIViewController) {
        let navVC = vc as? UINavigationController
        let vc = navVC?.viewControllers.first as? PaymentMethodViewController
        vc?.delegate = viewController
    }

}
