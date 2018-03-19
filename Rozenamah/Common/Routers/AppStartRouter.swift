//
//  AppStartRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 15.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol AppStartRouter {
    func navigateToApp()
}

extension AppStartRouter where Self: Router {
    
    func navigateToSignUp() {
        if let signUpVC = UIStoryboard(name: "Session", bundle: nil).instantiateViewController(withIdentifier: "welcome_navigation") as? UINavigationController {
            
            UIApplication.shared.keyWindow?.setRootViewController(signUpVC, options: UIWindow.TransitionOptions(direction: .fade))
        }
    }
    
    func navigateToApp() {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController(),
            let sideBarVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "side_vc") as? DrawerViewController else {
                return
        }
        
        
        let slideMenuController = SlideMenuController(mainViewController: homeVC,
                                                      leftMenuViewController: sideBarVC)
        
        UIApplication.shared.keyWindow?.setRootViewController(slideMenuController, options: UIWindow.TransitionOptions(direction: .fade))
        
    }
    
    private func changeRootViewController(with vc: UIViewController) {
        if let window: UIWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            UIView.transition(with: window,
                              duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                
                                window.rootViewController = vc
                                
            }, completion: nil)
        }
    }
}

