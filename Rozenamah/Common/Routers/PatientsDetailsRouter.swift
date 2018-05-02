//
//  PatientDetailsRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 02.05.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PatientsDetailsRouter {
    func passVisitDetails(vc: UIViewController)
}

// Add protocol to ViewControllers that have booking, so later we can pass booking to next VC
protocol VisitBooking {
    var booking: Booking! { get set }
}

extension PatientsDetailsRouter where Self: Router {
    
    func passVisitDetails(vc: UIViewController) {
        let routingVC = viewController as? VisitBooking
        let navVC = vc as? UINavigationController
        let detailsVC = navVC?.visibleViewController as? PatientDetailsViewController
        detailsVC?.booking = routingVC?.booking
    }
}
