//
//  Visit.swift
//  Rozenamah
//
//  Created by Dominik Majda on 18.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

class Cost: Decodable {
    let total: Int
    let price: Int
    let fee: Int
}

class VisitDetails: Decodable {
    private enum CodingKeys : String, CodingKey {
        case cost, user = "doctor", latitude, longitude
    }
    
    let cost: Cost
    let user: User
    var latitude: Double
    var longitude: Double
    
    var distanceInKM: Double {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        var meters: Double = 0
        
        //added by Najam
        if LoginUserManager.sharedInstance.userType == .doctor {
            if let currentUserLocation = CLLocationManager().location {
                meters = currentUserLocation.distance(from: coordinates)
            }
        } else {
            let currentUserLocation = CLLocation(latitude: LoginUserManager.sharedInstance.newPatientLocation?.latitude ?? 0, longitude: LoginUserManager.sharedInstance.newPatientLocation?.longitude ?? 0)
                meters = currentUserLocation.distance(from: coordinates)
        }
        meters = meters/1000
        return Double(round(10*meters)/10)
    }
    
    var doctorLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
