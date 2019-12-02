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
    case waitingForPayment = "waiting_for_payment"
    
    var title: String {
        switch self {
        case .new: return "generic.new".localized
        case .accepted: return "generic.accepted".localized
        case .rejected: return "generic.rejected".localized
        case .canceled: return "generic.canceled".localized
        case .timeout: return "generic.timeout".localized
        case .arrived: return "generic.arrived".localized
        case .ended: return "generic.ended".localized
        case .waitingForPayment: return "generic.waitingForPayment".localized
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
    var latitude: Double
    var longitude: Double
    var status: BookingStatus
    let payment: PaymentMethod
    let address: String?
    let dates: Dates?
    
    var patientLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
