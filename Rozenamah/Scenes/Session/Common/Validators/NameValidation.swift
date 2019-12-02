//
//  NameValidation.swift
//  Rozenamah
//
//  Created by Dominik Majda on 27.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class NameValidation {
    
    class func validate(name testString: String) -> Bool {
        let whiteSpacesSet = CharacterSet.whitespacesAndNewlines
        return testString.trimmingCharacters(in: whiteSpacesSet).count >= 3
    }
    
}
