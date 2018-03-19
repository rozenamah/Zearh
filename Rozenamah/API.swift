//
//  API.swift
//  Rozenamah
//
//  Created by Dominik Majda on 14.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

enum API {
    case login
    case register
    case me
    case logout
}

extension API {
    
    var path: String {
        let baseURL = "https://rozenamah.herokuapp.com/"
        switch self {
        case .login: return baseURL + "login/"
        case .register: return baseURL + "register/"
        case .me: return baseURL + "me/"
        case .logout: return baseURL + "logout/"
        }
    }
    
}
