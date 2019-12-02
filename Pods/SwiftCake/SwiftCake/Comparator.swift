//
//  Comparator.swift
//  SwiftCake
//
//  Created by Dominik Majda on 01.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

public final class Comparator {
    
    public let date: Date
    
    public init(_ date: Date) {
        self.date = date
    }
    
}

extension Comparator {
    
    public func compareToNow(unit: Calendar.Component) -> Int {
        return compare(to: Date(), unit: unit)
    }
    
    public func compare(to date: Date, unit: Calendar.Component) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([unit, ], from: self.date, to: date)
        return components.value(for: unit)!
    }
}

extension Date {
    
    public var compare: Comparator {
        return Comparator(self)
    }
    
    public func resetToMidnight() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
}
