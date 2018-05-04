//
//  AppRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 20.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class AppRouter {
    
    static func navigateToProperScreen(from userInfo: [AnyHashable: Any]) {
        
        guard let booking = decodeObject(toType: Booking.self, from: userInfo) else {
            return
        }
  
        if booking.status == .new {
            MainDoctorRouter.resolve(booking: booking)
        } else if booking.status == .accepted {
            WaitRouter.resolve(booking: booking, with: .accepted)
        } else {
            WaitRouter.resolve(booking: booking, with: .rejected)
        }
    }
    
    private static func decodeObject<H: Decodable>(toType: H.Type, from userInfo: [AnyHashable: Any]) -> H? {
        if let info = userInfo["info"] as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
                let decoder = JSONDecoder()
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
