import UIKit

class AcceptPatientRouter: Router, PhoneCallRouter {
    typealias RoutingViewController = AcceptPatientViewController
    weak var viewController: AcceptPatientViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func navigateToPatientsDetails() {
        viewController?.performSegue(withIdentifier: "patient_details_segue", sender: nil)
    }

    // MARK: Passing data

}
