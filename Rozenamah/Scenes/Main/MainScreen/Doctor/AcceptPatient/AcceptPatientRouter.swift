import UIKit

class AcceptPatientRouter: Router, PhoneCallRouter {
    typealias RoutingViewController = AcceptPatientViewController
    weak var viewController: AcceptPatientViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patient_details_segue", let visitDetails = sender as? VisitDetails {
            passVisitDetials(segue.destination, visitDetails: visitDetails)
        }
    }

    // MARK: Navigation
    
    func navigateToPatientDetails(_ patient: VisitDetails) {
        viewController?.performSegue(withIdentifier: "patient_details_segue", sender: patient)
    }

    // MARK: Passing data
    
    private func passVisitDetials(_ vc: UIViewController, visitDetails: VisitDetails) {
        let navVC = vc as? UINavigationController
        let patientDetailVC = navVC?.visibleViewController as! PatientDetailsViewController
        patientDetailVC.visitDetails = visitDetails
    }


}
