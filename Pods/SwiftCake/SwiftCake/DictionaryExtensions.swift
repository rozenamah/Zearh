//
//  DictionaryExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 07.05.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

extension Dictionary {
    public mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
