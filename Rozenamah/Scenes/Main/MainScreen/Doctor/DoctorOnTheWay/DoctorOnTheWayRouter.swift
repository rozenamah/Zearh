import UIKit

class DoctorOnTheWayRouter: Router, AlertRouter, PatientsDetailsRouter {
    typealias RoutingViewController = DoctorOnTheWayViewController
    weak var viewController: DoctorOnTheWayViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation

    // MARK: Passing data

}
