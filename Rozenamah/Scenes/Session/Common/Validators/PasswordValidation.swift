//
//  PasswordValidation.swift
//  Rozenamah
//
//  Created by Dominik Majda on 27.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class PasswordValidation {
    
    class func validate(password testString: String) -> Bool {
        var alphanumericSet = CharacterSet.alphanumerics
        alphanumericSet.insert(charactersIn: "!@#$%^&*_-")
        return testString.trimmingCharacters(in: alphanumericSet).isEmpty
    }
    
}
