import UIKit

class DoctorLocationRouter: Router, AlertRouter {
    typealias RoutingViewController = DoctorLocationViewController
    weak var viewController: DoctorLocationViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showFeeAlert() {
        let alert = UIAlertController(title: "Canecllation Alert", message: "Are you sure you want to cancel this visit? You will be charged 5% of this visit price next time you order a visit!", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            self.viewController?.cancelConfirmed()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Passing data

}
