//
//  Booking.swift
//  Rozenamah
//
//  Created by Dominik Majda on 23.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

enum BookingStatus: String, Decodable {
    case new = "new"
    case accepted = "accepted"
    case rejected = "rejected"
}

class Booking: Decodable {
    private enum CodingKeys : String, CodingKey {
        case id, visit = "doctor", patient = "user", latitude, longitude, status
    }
    
    let id: String
    let visit: VisitDetails
    let patient: User
    let latitude: Double
    let longitude: Double
    let status: BookingStatus
    
    var patientLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
