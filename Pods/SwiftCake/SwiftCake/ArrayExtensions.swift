//
//  ArrayExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 15.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
   
    /// Remove first collection element that is equal to the given `object`
    /// http://stackoverflow.com/questions/24938948/array-extension-to-remove-object-by-value
    ///
    /// - Parameter object: item to remove
    public mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
