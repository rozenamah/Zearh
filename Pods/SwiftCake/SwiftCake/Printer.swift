//
//  Printer.swift
//  SwiftCake
//
//  Created by Dominik Majda on 01.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation


public final class Printer {
    
    public let date: Date
    public let df: DateFormatter
    
    fileprivate var settings = PrinterSettings.shared
    
    public init(_ date: Date) {
        self.date = date
        self.df = DateFormatter()
    }
    
}

extension Printer {
    
    public func with(style: DateFormatter.Style) -> String {
        df.dateStyle = style
        return df.string(from: date)
    }
    
}

extension Printer {
    
    public func string(with format: String) -> String {
        df.dateFormat = format
        return df.string(from: date)
    }
    
    public func string(_ key: CustomStringConvertible) -> String {
        return string(key.description)        
    }
    
    public func string(_ key: String) -> String {
        
        guard let value = settings.formats[key] else {
            fatalError("No such key: \"\(key)\" registered! User PrinterSettings.shared to register key and format")
        }
        df.dateFormat = value
        return df.string(from: date)
        
    }
    
}


extension Date {
    
    public var printer: Printer {
        return Printer(self)
    }
    
}
