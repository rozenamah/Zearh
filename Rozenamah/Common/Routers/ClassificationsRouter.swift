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
    func navigateToSelectingClassification()
    func navigateToSelectingSpecialization()
}

extension ClassificationRouter where Self: Router {
    
    func navigateToSelectingSpecialization() {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert = UIAlertController(title: "Specialization", message: "Please choose your specialization", preferredStyle: .actionSheet)
        DoctorSpecialization.all.forEach { (specialization) in
            alert.addAction(UIAlertAction(title: specialization.title, style: .default, handler: { (action) in
                // Cast view controller as delegate to get appropriate specialization
                (viewController as? ClassificationDelegate)?.specializationSelected(specialization)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func navigateToSelectingClassification() {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert = UIAlertController(title: "Classification", message: "Please choose your classification", preferredStyle: .actionSheet)
        Classification.all.forEach { (classification) in
            alert.addAction(UIAlertAction(title: classification.title, style: .default, handler: { (action) in
                // Cast view controller as delegate to get appropriate classification
                (viewController as? ClassificationDelegate)?.classificationSelected(classification)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
