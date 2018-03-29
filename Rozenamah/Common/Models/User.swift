//
//  User.swift
//  Rozenamah
//
//  Created by Dominik Majda on 16.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

enum UserType: String, Decodable {
    case doctor, patient
}

class User: Decodable {
    
    let id: String
    let name: String
    let surname: String
    let email: String
    var avatar: String?
    let type: UserType

    var avatarURL: URL? {
        if let avatar = avatar {
            return URL(string: avatar)
        }
        return nil
    }
    
    var fullname: String {
        return "\(name) \(surname)"
    }
    
    // Represents currently logged user, assigned on login, removed on logout
    static var current: User?
    
    
}
