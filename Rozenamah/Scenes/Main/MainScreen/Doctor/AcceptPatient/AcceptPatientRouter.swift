import UIKit

class AcceptPatientRouter: Router, PhoneCallRouter, AlertRouter, PatientsDetailsRouter {
    typealias RoutingViewController = AcceptPatientViewController
    weak var viewController: AcceptPatientViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation

    // MARK: Passing data
    
}
