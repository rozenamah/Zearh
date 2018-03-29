import UIKit

class CallDoctorRouter: Router, ClassificationRouter {
    typealias RoutingViewController = CallDoctorViewController
    weak var viewController: CallDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func navigateToExtendedFilters() {
        viewController?.parent?.performSegue(withIdentifier: "change_filters_segue", sender: nil)
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
