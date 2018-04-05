import UIKit

class MainPatientRouter: NSObject, Router {
    typealias RoutingViewController = MainPatientViewController
    weak var viewController: MainPatientViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation
    
    func navigateToCallDoctor() {
        guard let containerView = viewController?.containerView else {
            return
        }
        
        // Animate container from bottom to top
        var originalFrame = containerView.frame
        originalFrame.origin.y = UIScreen.main.bounds.height - containerView.frame.height
        if #available(iOS 11, *) {
            originalFrame.origin.y -= viewController?.view.safeAreaInsets.bottom ?? 0
        }
        var animationFrame = originalFrame
        animationFrame.origin.y = UIScreen.main.bounds.height
        containerView.frame = animationFrame
        
        // Move up
        containerView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            containerView.frame = originalFrame
        }, completion: nil)
    }
    
    // MARK: Passing data

}
