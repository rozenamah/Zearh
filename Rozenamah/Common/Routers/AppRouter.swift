//
//  AppRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 20.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class AppRouter {
    
    static func navigateToAcceptVisit(from userInfo: [AnyHashable: Any]) {
  
        if let visitInfo = decodeObject(from: userInfo) {
            MainDoctorRouter.resolve(visit: visitInfo)
        }
    }
    
     private static func decodeObject(from userInfo: [AnyHashable: Any]) -> VisitDetails? {
        if let aps = userInfo["aps"] as? [String: Any], let info = aps["info"] as? [String: Any] {
            print(info)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let data = try decoder.decode(VisitDetails.self, from: jsonData)
                return data
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        }
        return nil
    }
}
