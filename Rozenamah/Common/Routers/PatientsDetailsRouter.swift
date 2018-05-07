//
//  PatientDetailsRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 02.05.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PatientsDetailsRouter {
    func navigateToPatient(inBooking booking: Booking)
}

extension PatientsDetailsRouter where Self: Router {
    
    func navigateToPatient(inBooking booking: Booking) {
        
        
        guard let viewcontroller = viewController as? UIViewController else {
            return
        }
        
        if let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "patient_details_vc") as? UINavigationController {
            
            let detailsVC = navVC.visibleViewController as? PatientDetailsViewController
            detailsVC?.booking = booking
            viewcontroller.present(navVC, animated: true, completion: nil)
        }
    
    }
}
