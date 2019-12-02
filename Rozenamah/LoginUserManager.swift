//
//  LoginUserManager.swift
//  Rozenamah
//
//  Created by MacPro on 9/24/19.
//  Copyright © 2019 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation

class LoginUserManager{
    private init() { }
    static let sharedInstance = LoginUserManager()
    
//    var LoginUserData:LoginUserData!
    
    var visitFound = false
    var isMianScreen = true
    var bookingStatus: BookingStatus?
    var lastBooking:Booking?

    var timer = Timer()
    var newPatientLocation:CLLocationCoordinate2D?
    var userType:UserType = .patient
}
