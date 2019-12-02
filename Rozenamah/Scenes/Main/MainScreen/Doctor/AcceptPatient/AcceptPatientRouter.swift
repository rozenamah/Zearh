import UIKit

class AcceptPatientRouter: Router, PhoneCallRouter, AlertRouter, PatientsDetailsRouter {
    typealias RoutingViewController = AcceptPatientViewController
    weak var viewController: AcceptPatientViewController?

    // MARK: Routing
    private var alertLoading: UIAlertController?


    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation

    // MARK: Passing data
    
    
    func showWaitAlert(sender:UIView) {
        alertLoading = showLoadingAlertwithoutText(sender: sender)
    }
    
    func hideWaitAlert() {
        alertLoading?.dismiss(animated: true, completion: nil)
    }
}
