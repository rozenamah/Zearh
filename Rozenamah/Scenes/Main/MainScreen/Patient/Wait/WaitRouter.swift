import UIKit

class WaitRouter: Router, AlertRouter {
    typealias RoutingViewController = WaitViewController
    weak var viewController: WaitViewController?
    
    // MARK: Routing
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation
    
    func showCancelAlert(forBooking booking: Booking) {
        let alert = UIAlertController(title: "Cancel visit", message: "Are you sure you want to cancel this visit?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed(forBooking: booking)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }

    
    func showNoDoctorFound() {
        let alert = UIAlertController(title: "Sorry", message: "We can't find any doctor matching your criteria", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.viewController?.flowDelegate?.changeStateTo(flowPoint: .callDoctor)
        }))
        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Passing data

}
