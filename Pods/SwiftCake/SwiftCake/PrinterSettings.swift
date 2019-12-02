//
//  PrinterSettings.swift
//  SwiftCake
//
//  Created by Dominik Majda on 01.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

public final class PrinterSettings {
    
    /// Singleton instance to printer settings
    public static let shared = PrinterSettings()
    
    internal var formats = [String: String]()
    
    private init() {
    }
    
    public func register(key: String, format: String?) {
        formats[key] = format
    }
    
    public func register<T>(key: T, format: String?) where T: CustomStringConvertible {
        formats[key.description] = format
    }
}
