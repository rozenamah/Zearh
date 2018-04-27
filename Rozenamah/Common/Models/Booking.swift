//
//  Booking.swift
//  Rozenamah
//
//  Created by Dominik Majda on 23.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

class Booking: Decodable {
    private enum CodingKeys : String, CodingKey {
        case id, visit = "doctor", patient = "user", latitude, longitude
    }
    
    let id: String
    let visit: VisitDetails
    let patient: User
    var latitude: Double
    var longitude: Double
}
