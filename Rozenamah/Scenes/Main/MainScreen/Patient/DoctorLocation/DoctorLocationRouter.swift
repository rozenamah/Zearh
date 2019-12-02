import UIKit

class DoctorLocationRouter: Router, AlertRouter, PhoneCallRouter {
    typealias RoutingViewController = DoctorLocationViewController
    weak var viewController: DoctorLocationViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showFeeAlert(sender:UIView) {
        let alert = UIAlertController(title: "alerts.cancelVisit.title".localized,
                                      message: "alerts.cancelVisit.feeMessage".localized, preferredStyle: .alert)
        
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

}
