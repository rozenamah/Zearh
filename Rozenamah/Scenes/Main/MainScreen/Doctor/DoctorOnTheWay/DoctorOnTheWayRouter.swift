import UIKit

class DoctorOnTheWayRouter: Router, AlertRouter, PatientsDetailsRouter, PhoneCallRouter {
    typealias RoutingViewController = DoctorOnTheWayViewController
    weak var viewController: DoctorOnTheWayViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation

    func showCancelAlert() {
        let alert = UIAlertController(title: "Cancel visit", message: "Are you sure you want to cancel this visit?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Passing data

}
