//
//  EmailValidation.swift
//  Rozenamah
//
//  Created by Dominik Majda on 13.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class EmailValidation {
    
    class func validate(email testString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
}
