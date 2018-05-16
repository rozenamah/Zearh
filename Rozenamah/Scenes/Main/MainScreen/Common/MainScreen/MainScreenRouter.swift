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
    
    lazy var locationVC: LocationAlertViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "location_alert_vc") as! LocationAlertViewController
        return vc
    }()
    
    lazy var notificationVC: NotificationAlertViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notification_alert_vc") as! NotificationAlertViewController
        return vc
    }()
    
    func navigateToNoLocation() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.locationVC)
            self.baseViewController?.containerHeightConstraint.constant = 363
            
            self.openContainer()
        }
    }
    
    func navigateToNoPushPermission() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.notificationVC)
            self.baseViewController?.containerHeightConstraint.constant = 363
            
            self.openContainer()
        }
    }
    
    func animateCloseContainer(completion: @escaping (()->Void)) {
        if let animateConstraint = baseViewController?.containerBottomConstraint,
            let containerHeightConstraint = baseViewController?.containerHeightConstraint {
            
            animateConstraint.constant = containerHeightConstraint.constant
            
            UIView.animate(withDuration: 0.4, animations: {
                self.baseViewController?.view.layoutIfNeeded()
            }, completion: { (_) in
                completion()
            })
        }
    }
    
    func animateOpenContainer(completion: (()->Void)? = nil) {
        guard let containerView = baseViewController?.containerView, let animateConstraint = baseViewController?.containerBottomConstraint else {
                return
        }
        
        // Animate container from bottom to top
        animateConstraint.constant = 0
        containerView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.baseViewController?.view.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }
    
    // MARK: Passing data
    
    func openContainer(completion: (()->Void)? = nil) {
        animateOpenContainer(completion: completion)
    }
    
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
