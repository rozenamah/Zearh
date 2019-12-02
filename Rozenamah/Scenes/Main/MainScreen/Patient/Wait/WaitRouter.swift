import UIKit

class WaitRouter: Router, AlertRouter {
    typealias RoutingViewController = WaitViewController
    weak var viewController: WaitViewController?
    
    /// Alert view, displayed when canceling search
    private var alertLoading: UIAlertController?
    
    // MARK: Routing
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation
    
    func showCancelAlert(forBooking booking: Booking,sender:UIView) {
        let alert = UIAlertController(title: "alerts.cancelVisit.title".localized,
                                      message: "alerts.cancelVisit.message".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "generic.confirm".localized, style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed(forBooking: booking)
        }))
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
    }

    
    func showNoDoctorFound(sender:UIView) {
        let alert = UIAlertController(title: "alerts.cantFindDoctor.title".localized,
                                      message: "alerts.cantFindDoctor.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { (_) in
            self.viewController?.flowDelegate?.changeStateTo(flowPoint: .callDoctor)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
    }

    func showWaitAlert() {
        alertLoading = showLoadingAlert(sender: viewController!.view)
    }
    
    func hideWaitAlert(completion: (() -> Void)? = nil) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
    
    // MARK: Passing data

}
