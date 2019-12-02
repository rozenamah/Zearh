//
//  ClassificationsRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 29.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol ClassificationDelegate: class {
    func classificationSelected(_ classification: Classification)
    func specializationSelected(_ specialization: DoctorSpecialization)
}

protocol ClassificationRouter {
    func navigateToSelectingClassification(sender:Any)
    func navigateToSelectingSpecialization(sender:Any)
}

extension ClassificationRouter where Self: Router {
    
    func navigateToSelectingSpecialization(sender:Any) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert = UIAlertController(title: "generic.specialization".localized, message: "session.doctor.specialization".localized, preferredStyle: .actionSheet)
        DoctorSpecialization.all.forEach { (specialization) in
            alert.addAction(UIAlertAction(title: specialization.title, style: .default, handler: { (action) in
                // Cast view controller as delegate to get appropriate specialization
                (viewController as? ClassificationDelegate)?.specializationSelected(specialization)
            }))
        }
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender as! UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func navigateToSelectingClassification(sender:Any) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert = UIAlertController(title: "generic.classification".localized, message: "session.doctor.classification".localized, preferredStyle: .actionSheet)
        Classification.all.forEach { (classification) in
            alert.addAction(UIAlertAction(title: classification.title, style: .default, handler: { (action) in
                // Cast view controller as delegate to get appropriate classification
                (viewController as? ClassificationDelegate)?.classificationSelected(classification)
            }))
        }
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender as! UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
