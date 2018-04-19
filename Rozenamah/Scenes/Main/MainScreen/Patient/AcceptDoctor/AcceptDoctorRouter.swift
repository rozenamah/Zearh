import UIKit

class AcceptDoctorRouter: Router, PhoneCallRouter {
    typealias RoutingViewController = AcceptDoctorViewController
    weak var viewController: AcceptDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment_method_segue" {
            passToPaymentMethod(segue.destination)
        }

    }

    // MARK: Navigation
    
    func navigateToPaymentMethod() {
        viewController?.performSegue(withIdentifier: "payment_method_segue", sender: nil)
    }

    // MARK: Passing data
    
    private func passToPaymentMethod(_ vc: UIViewController) {
        let navVC = vc as? UINavigationController
        let vc = navVC?.visibleViewController as? PaymentMethodViewController
        vc?.delegate = viewController
        vc?.doctor = viewController?.doctor
    }

}
