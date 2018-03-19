//
//  AlertRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 13.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol AlertRouter {
    func showAlert(message: String)
    func showError(_ error: Error)
}

extension AlertRouter where Self: Router {
    
    /// In default implementation it returns alert with "loading" text in it.
    /// It is than a caller responsibility to dimiss it
    @discardableResult
    func showLoadingAlert() -> UIAlertController {
        
        let vc = viewController as? UIViewController
        
        let alertMessage = UIAlertController(title: nil,
                                               message: "Please wait",
                                               preferredStyle: .alert)
        
        vc?.present(alertMessage, animated: true, completion: nil)
        return alertMessage
    }
    
    func showAlert(message: String) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert = UIAlertController(title: nil,
                                                             message: message,
                                                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func showError(_ error: Error) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alertMessage = UIAlertController(title: "Ups",
                                               message: error.localizedDescription,
                                               preferredStyle: .alert)
        
        alertMessage.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alertMessage, animated: true, completion: nil)
        
        
    }
    
}

