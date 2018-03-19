//
//  Settings.swift
//  Rozenamah
//
//  Created by Dominik Majda on 19.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

class Settings {
    
    static let shared = Settings()
    
    // Here we store settings
    private let defaults = UserDefaults(suiteName: "settings")!
    
    private init() {
    }
    
    /// Returns if app is ran for the first time
    var isFirstAppRun: Bool {
        get {
            return defaults.bool(forKey: "firstRun")
        }
        set {
            defaults.set(newValue, forKey: "firstRun")
        }
    }
    
}
