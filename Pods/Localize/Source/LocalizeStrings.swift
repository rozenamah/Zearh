//
//  LocalizeStrings.swift
//  Localize
//
//  Copyright © 2017 Kekiiwaa. All rights reserved.
//

import UIKit

class LocalizeStrings: LocalizeCommonProtocol {
    
    /// Create default lang name
    override init() {
        super.init()
        fileName = "Strings"
    }
    
    /// Show all aviable languajes whit criteria name
    ///
    /// - returns: list with storaged languages code
    override var availableLanguages: [String] {
        var availableLanguages = bundle.localizations
        if let indexOfBase = availableLanguages.index(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    // MARK: Public methods
    
    
    /// Localize a string using your JSON File
    /// If the key is not found return the same key
    /// That prevent replace untagged values
    ///
    /// - returns: localized key or same text
    public override func localize(key: String, tableName: String? = nil) -> String {
        let tableName = tableName ?? fileName
        if let path = bundle.path(forResource: currentLanguage, ofType: "lproj") {
            let bundle = Bundle(path: path)!
            let localized = bundle.localizedString(forKey: key, value: nil, table: tableName)
            if localized != key {
                return localized
            }
        }
        if let path = bundle.path(forResource: defaultLanguage, ofType: "lproj") {
            let bundle = Bundle(path: path)!
            return bundle.localizedString(forKey: key, value: nil, table: tableName)
        }
        return key
    }
}
