import UIKit

class MainPatientRouter: NSObject, Router {
    typealias RoutingViewController = MainPatientViewController
    weak var viewController: MainPatientViewController?
    
    // Handling of view controllers state
    private var currentViewController: UIViewController!

    lazy var waitVC: WaitViewController = {
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wait_vc") as! WaitViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var callFormVC: CallDoctorViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "call_vc") as! CallDoctorViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation
    
    /// Adds call doctor form at app start
    func configureFirstScreen() {
        add(asChildViewController: callFormVC)
        viewController?.containerHeightConstraint.constant = 433
    }
    
    func openContainer(completion: (()->Void)? = nil) {
        animateOpenContainer(completion: completion)
    }
    
    func closeContainer() {
        animateCloseContainer {
            // Do nothing
        }
    }
    
    func navigateToCallForm() {
        animateCloseContainer {[weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.callFormVC)
            self.viewController?.containerHeightConstraint.constant = 433
            self.openContainer()
        }
    }
    
    func navigateToWaitScreen() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.waitVC)
            self.viewController?.containerHeightConstraint.constant = 202
            self.openContainer()
        }
    }
    
    private func animateCloseContainer(completion: @escaping (()->Void)) {
        if let containerView = viewController?.containerView {
            var animateFrame = containerView.frame
            animateFrame.origin.y = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.4, animations: {
                containerView.frame = animateFrame
            }, completion: { (_) in
                completion()
            })
        }
    }
    
    private func animateOpenContainer(completion: (()->Void)? = nil) {
        guard let containerView = viewController?.containerView,
            let viewHeight = viewController?.containerHeightConstraint.constant else {
            return
        }
        
        // Animate container from bottom to top
        var originalFrame = containerView.frame
        originalFrame.origin.y = UIScreen.main.bounds.height - viewHeight
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
        }) { (_) in
            completion?()
        }
    }
    
    // MARK: Passing data
    
    
    fileprivate func add(asChildViewController childViewController: UIViewController) {
        guard let parentViewController = viewController else {
            return
        }
        
        // Add Child View Controller
        parentViewController.addChildViewController(childViewController)
        
        // Add Child View as Subview
        parentViewController.containerView.addSubview(childViewController.view)
        
        // Configure Child View
        childViewController.view.frame = parentViewController.containerView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Save current view controller
        currentViewController = childViewController
        
        // Notify Child View Controller
        childViewController.didMove(toParentViewController: parentViewController)
    }
    
    fileprivate func remove(asChildViewController childViewController: UIViewController) {
        
        // Notify Child View Controller
        childViewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        childViewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        childViewController.removeFromParentViewController()
    }


}
