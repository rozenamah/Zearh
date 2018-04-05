import UIKit

class CallDoctorRouter: Router, ClassificationRouter {
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
    
    /// This view is in container, we animate it so it goes down
    func dismiss() {
        if let containerView = viewController?.view.superview {
            var animateFrame = containerView.frame
            animateFrame.origin.y = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.4, animations: {
                containerView.frame = animateFrame
            })
        }
    }

    // MARK: Passing data

}
