//
//  User.swift
//  Rozenamah
//
//  Created by Dominik Majda on 16.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class User: Decodable {
    
    let id: Int
    let name: String
    let surname: String
    let email: String
    
    var fullname: String {
        return "\(name) \(surname)"
    }
    
    // Represents currently logged user, assigned on login, removed on logout
    static var current: User?
    
    
}
