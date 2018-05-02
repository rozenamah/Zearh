import UIKit

class DoctorOnTheWayRouter: Router, AlertRouter, PatientsDetailsRouter {
    typealias RoutingViewController = DoctorOnTheWayViewController
    weak var viewController: DoctorOnTheWayViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details_segue" {
            passVisitDetails(vc: segue.destination)
        }
    }

    // MARK: Navigation
    
    func navigateToPatientDetails() {
        viewController?.performSegue(withIdentifier: "details_segue", sender: nil)
    }

    // MARK: Passing data

}
