//
//  AlertRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 13.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import Localize

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
                                               message: "alerts.pleaseWait.pleaseWait".localized,
                                               preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        alertMessage.view.addSubview(indicator)
        
        let views = ["pending" : alertMessage.view!, "indicator" : indicator]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator]-(-50)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|[indicator]|", options: [], metrics: nil, views: views)
        alertMessage.view.addConstraints(constraints)
        
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
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
       
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

    
    func showError(_ error: Error) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let message = error.localizedDescription.localizedError ?? error.localizedDescription
    
        let alertMessage = UIAlertController(title: "generic.error.ups".localized,
                                               message: error.localizedDescription,
                                               preferredStyle: .alert)
        
        alertMessage.addAction(UIAlertAction(title: "generic.ok".localized, style: .cancel, handler: nil))
        viewController.present(alertMessage, animated: true, completion: nil)
    }
    
}

