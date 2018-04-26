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
        case refresh
        case me
        case verifyEmail
        case verifyPhone
        case resetPassword
        case logout
        case devices
        case changePassword
        case updateProfile
        case updateAvatar
        case report
        
        var resource: String { return baseURL + "user/" }
    }
    
    enum Patient {
        case upgrade
        
        var resource: String { return baseURL + "patient/" }
    }
    
    enum Doctor {
        case availability
        case position
        case search
        case nearby
        
        var resource: String { return baseURL + "doctor/" }
    }
    
    enum Visit {
        case request
        case accept
        case reject
        case cancel
        
        var resource: String { return baseURL + "visit/" }
    }
    
    enum Transaction {
        case history
        var resource: String { return baseURL + "history/" }
    }
}

extension API.Doctor {
    var path: String {
        switch self {
        case .availability: return resource + "availability"
        case .position: return resource + "position"
        case .search: return resource + "search"
        case .nearby: return resource + "nearby"
        }
    }
}

extension API.Patient {
    var path: String {
        switch self {
        case .upgrade: return resource + "upgrade"
        }
    }
}

extension API.Visit {
    var path: String {
        switch self {
        case .request: return resource + "request"
        case .accept: return resource + "accept"
        case .reject: return resource + "reject"
        case .cancel: return resource + "cancel"
        }
    }
}

extension API.User {
    var path: String {
        switch self {
        case .login: return resource + "login"
        case .register: return resource + "register"
        case .refresh: return resource + "token/refresh"
        case .resetPassword: return resource + "password/restore"
        case .verifyEmail: return resource + "email/check"
        case .verifyPhone: return resource + "phone/check"
        case .me: return resource + "me"
        case .logout: return resource + "logout"
        case .devices: return resource + "devices"
        case .changePassword: return resource + "password/change"
        case .updateProfile: return resource + "update"
        case .updateAvatar: return resource + "avatar"
        case .report: return resource + "report"
        }
    }
}

extension API.Transaction {
    var path: String {
        switch self {
        case .history: return resource
        }
    }
}
