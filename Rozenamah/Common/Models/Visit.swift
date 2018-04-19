//
//  Visit.swift
//  Rozenamah
//
//  Created by Dominik Majda on 18.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

class Visit: Decodable {
    let phone: String?
    let price: Int
    let fee: Int
    let address: String?
    var latitude: Double
    var longitude: Double
    
    var distanceInKM: Int {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        var meters: Int = 0
        if let currentUserLocation = CLLocationManager().location {
            meters = Int(currentUserLocation.distance(from: coordinates))
        }
        return (meters/1000)
    }
}

class DoctorResult: Decodable {
    let visit: Visit
    let user: User
}
