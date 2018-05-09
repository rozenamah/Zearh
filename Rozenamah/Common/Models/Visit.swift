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
    let latitude: Double
    let longitude: Double
    
    var distanceInKM: Int {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        var meters: Int = 0
        if let currentUserLocation = CLLocationManager().location {
            meters = Int(currentUserLocation.distance(from: coordinates))
        }
        return (meters/1000)
    }
    
    var doctorLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
