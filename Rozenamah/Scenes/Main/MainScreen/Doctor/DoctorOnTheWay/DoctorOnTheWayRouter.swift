import UIKit

class DoctorOnTheWayRouter: Router, AlertRouter, PatientsDetailsRouter, PhoneCallRouter {
    typealias RoutingViewController = DoctorOnTheWayViewController
    weak var viewController: DoctorOnTheWayViewController?

    // MARK: Routing
    
    private var alertLoading: UIAlertController?


    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation

    func showCancelAlert(sender:UIView) {
        let alert = UIAlertController(title: "alerts.cancelVisit.title".localized,
                                      message: "alerts.cancelVisit.message".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "generic.confirm".localized, style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed()
        }))
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    
    func showWaitAlert(sender:UIView) {
        alertLoading = showLoadingAlertwithoutText(sender: sender)
    }
    
    func hideWaitAlert() {
        alertLoading?.dismiss(animated: true, completion: nil)
    }

}
