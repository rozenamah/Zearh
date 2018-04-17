//
//  KeychainExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 15.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    
    static var shared: Keychain {
        return Keychain(service: "com.Rozenamah.token")
    }
    
    var refreshToken: String? {
        get {
            return self["refresh_token"]
        }
        set {
            self["refresh_token"] = newValue
        }
    }
    
    var token: String? {
        get {
            return self["token"]
        }
        set {
            self["token"] = newValue
        }
    }
}
