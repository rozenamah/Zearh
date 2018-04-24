import UIKit

class BusyDoctorRouter: Router {
    typealias RoutingViewController = BusyDoctorViewController
    weak var viewController: BusyDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details_segue" {
            passVisitInfo(vc: segue.destination)
        }

    }

    // MARK: Navigation
    
    func navigateToPatientDetails() {
        viewController?.performSegue(withIdentifier: "details_segue", sender: viewController?.visitInfo)
    }

    // MARK: Passing data
    
    private func passVisitInfo(vc: UIViewController) {
        let navVC = vc as? UINavigationController
        let detailsVC = navVC?.visibleViewController as? PatientDetailsViewController
        detailsVC?.visitDetails = viewController?.visitInfo
    }
}
