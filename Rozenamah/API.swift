//
//  API.swift
//  Rozenamah
//
//  Created by Dominik Majda on 14.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

fileprivate let baseURL = "https://rozenamah.r4s.ovh/api/"

enum API {
    
    enum User {
        case login
        case register
        case me
        case verifyEmail
        case resetPassword
        case logout
        case devices
        case changePassword
        case updateProfile
        
        var resource: String { return baseURL + "user/" }
    }
}

extension API.User {
    var path: String {
        switch self {
        case .login: return resource + "login"
        case .register: return resource + "register"
        case .resetPassword: return resource + "password/restore"
        case .verifyEmail: return resource + "email/check"
        case .me: return resource + "me"
        case .logout: return resource + "logout"
        case .devices: return resource + "devices"
        case .changePassword: return resource + "password/change"
        case .updateProfile: return resource + "update"
        }
    }
}
