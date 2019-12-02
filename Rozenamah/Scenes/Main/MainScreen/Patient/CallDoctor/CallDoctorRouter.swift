import UIKit

class CallDoctorRouter: Router, ClassificationRouter, AlertRouter {
    typealias RoutingViewController = CallDoctorViewController
    weak var viewController: CallDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "change_filters_segue":
            // Pass current filters
            let navVC = segue.destination as? UINavigationController
            let callDoctorFiltersVC = navVC?.visibleViewController as? CallDoctorFiltersViewController
            callDoctorFiltersVC?.callForm = viewController?.callForm
            callDoctorFiltersVC?.delegate = viewController
        default:
            return
        }
    }

    // MARK: Navigation
    
    func navigateToExtendedFilters() {
        viewController?.performSegue(withIdentifier: "change_filters_segue", sender: nil)
    }

    // MARK: Passing data

}
