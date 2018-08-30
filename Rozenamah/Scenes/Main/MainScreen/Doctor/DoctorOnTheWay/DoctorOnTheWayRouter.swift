import UIKit

class DoctorOnTheWayRouter: Router, AlertRouter, PatientsDetailsRouter, PhoneCallRouter {
    typealias RoutingViewController = DoctorOnTheWayViewController
    weak var viewController: DoctorOnTheWayViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation

    func showCancelAlert() {
        let alert = UIAlertController(title: "alerts.cancelVisit.title".localized,
                                      message: "alerts.cancelVisit.message".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "generic.confirm".localized, style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed()
        }))
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Passing data

}
