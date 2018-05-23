//
//  Booking.swift
//  Rozenamah
//
//  Created by Dominik Majda on 23.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

class Dates: Decodable {
    private enum CodingKeys : String, CodingKey {
        case requestedAt = "requested_at", acceptedAt = "accepted_at", arrivedAt = "arrived_at", endedAt = "ended_at"
    }
    
    let requestedAt: Date?
    let acceptedAt: Date?
    let arrivedAt: Date?
    let endedAt: Date?
}

enum BookingStatus: String, Decodable {
    case new = "new"
    case accepted = "accepted"
    case rejected = "rejected"
    case canceled = "canceled"
    case timeout = "timed_out"
    case arrived = "arrived"
    case ended = "ended"
    
    var title: String {
        switch self {
        case .new: return "New"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .canceled: return "Canceled"
        case .timeout: return "Timed out"
        case .arrived: return "Arrived"
        case .ended: return "Ended"
        }
    }
}

class Booking: Decodable {
    private enum CodingKeys : String, CodingKey {
        case id, visit = "doctor", patient = "user", latitude, longitude, status, payment, address, dates
    }
    
    let id: String
    let visit: VisitDetails
    let patient: User
    let latitude: Double
    let longitude: Double
    let status: BookingStatus
    let payment: PaymentMethod
    let address: String?
    let dates: Dates?
    
    var patientLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
