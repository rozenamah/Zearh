//
//  AppRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 20.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class AppRouter {
    
    static func navigateToScreen(from userInfo: [AnyHashable: Any]) {
        guard let booking = decodeObject(toType: Booking.self, from: userInfo) else {
            return
        }
        
        navigateTo(booking: booking)
    }
    
    static func navigateTo(booking: Booking) {
        // Navigate to doctor/patient router and show modal
        MainDoctorRouter.resolve(booking: booking)
        MainPatientRouter.resolve(booking: booking)
    }
    
    /// Called when refreshing state is saying there is no pending visit, so we should close any pending visit
    static func noVisit() {
        MainDoctorRouter.stopAllBookings()
        MainPatientRouter.stopAllBookings()
    }
    
    private static func decodeObject<H: Decodable>(toType: H.Type, from userInfo: [AnyHashable: Any]) -> H? {
        if let info = userInfo["info"] as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode(toType, from: jsonData)
                return data
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        }
        return nil
    }
}
