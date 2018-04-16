import UIKit

class AcceptDoctorRouter: Router {
    typealias RoutingViewController = AcceptDoctorViewController
    weak var viewController: AcceptDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func navigateToPaymentMethod() {
        viewController?.performSegue(withIdentifier: "payment_method_segue", sender: nil)
    }

    // MARK: Passing data

}
