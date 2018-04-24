//
//  MainScreenRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 12.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

class MainScreenRouter: NSObject {
    var baseViewController: MainScreenViewController? {
        return nil
    }
    
    // Handling of view controllers state
    private var currentViewController: UIViewController!
    
    func animateCloseContainer(completion: @escaping (()->Void)) {
        if let containerView = baseViewController?.containerView {
            var animateFrame = containerView.frame
            animateFrame.origin.y = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.4, animations: {
                containerView.frame = animateFrame
            }, completion: { (_) in
                completion()
            })
        }
    }
    
    func animateOpenContainer(completion: (()->Void)? = nil) {
        guard let containerView = baseViewController?.containerView,
            let viewHeight = baseViewController?.containerHeightConstraint.constant else {
                return
        }
        
        // Animate container from bottom to top
        var originalFrame = containerView.frame
        originalFrame.origin.y = UIScreen.main.bounds.height - viewHeight
        if #available(iOS 11, *) {
            originalFrame.origin.y -= baseViewController?.view.safeAreaInsets.bottom ?? 0
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
    
    
    func add(asChildViewController childViewController: UIViewController) {
        
        // Remove current view controller if possible
        removeCurrentChildController()
        
        guard let parentViewController = baseViewController else {
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
    
    func removeCurrentChildController() {
        
        guard let childViewController = currentViewController else {
            return
        }
        
        // Notify Child View Controller
        childViewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        childViewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        childViewController.removeFromParentViewController()
    }

}
