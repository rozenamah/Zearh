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
    func navigateToSignUp()
    func navigateToDefaultApp()
    func navigateToApp(inModule module: UserType)
}

extension AppStartRouter where Self: Router {
    
    func navigateToSignUp() {
        if let signUpVC = UIStoryboard(name: "Session", bundle: nil).instantiateViewController(withIdentifier: "welcome_navigation") as? UINavigationController {
            UIApplication.shared.keyWindow?.setRootViewController(signUpVC, options: UIWindow.TransitionOptions(direction: .fade))
        }
    }
    
    func navigateToDefaultApp() {
        guard let user = User.current else {
            return
        }
        
        // Check if there is any pending booking - if so, redirect to correct module
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let launchBooking = appDelegate.launchBooking {
            if launchBooking.visit.user == user {
                // Doctor module
                navigateToApp(inModule: .doctor)
            } else {
                // Patient module
                navigateToApp(inModule: .patient)
            }
            return
            
        }
        
        if user.type == .doctor {
            if user.doctor?.isVerified == true {
                // Only if doctor and verified
                navigateToApp(inModule: .doctor)
            } else {
                navigateToApp(inModule: .patient)
            }
        } else {
            navigateToApp(inModule: .patient)
        }
    }
    
    func navigateToApp(inModule module: UserType) {
        
        guard let sideBarVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "side_vc") as? DrawerViewController else {
                return
        }
        sideBarVC.currentMode = module
        
        let homeVC = module == .doctor ?
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map_doctor_vc") :
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map_patient_vc")
        
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

