//
//  File.swift
//  Rozenamah
//
//  Created by Dominik Majda on 11.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class PhoneValidation {
    
    class func validate(phone testString: String) -> Bool {
        let phoneRegexEx = "^((\\+)|(00))?[0-9]{6,14}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegexEx)
        return phoneTest.evaluate(with: testString)
    }
    
}
