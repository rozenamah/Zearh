import UIKit

class PatientDetailsRouter: Router {
    typealias RoutingViewController = PatientDetailsViewController
    weak var viewController: PatientDetailsViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
