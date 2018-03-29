import UIKit

class CallDoctorFiltersRouter: Router, ClassificationRouter {
    typealias RoutingViewController = CallDoctorFiltersViewController
    weak var viewController: CallDoctorFiltersViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
