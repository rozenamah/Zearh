import UIKit

class AcceptPatientRouter: Router, PhoneCallRouter, AlertRouter {
    typealias RoutingViewController = AcceptPatientViewController
    weak var viewController: AcceptPatientViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patient_details_segue" {
            passVisitDetials(segue.destination)
        }
    }

    // MARK: Navigation
    
    func navigateToPatientDetails() {
        viewController?.performSegue(withIdentifier: "patient_details_segue", sender: nil)
    }

    // MARK: Passing data
    
    private func passVisitDetials(_ vc: UIViewController) {
        let navVC = vc as? UINavigationController
        let patientDetailVC = navVC?.visibleViewController as! PatientDetailsViewController
        patientDetailVC.visitDetails = viewController?.visitInfo
    }


}
