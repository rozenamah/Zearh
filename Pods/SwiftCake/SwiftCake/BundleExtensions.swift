//
//  BundleExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 12.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

extension Bundle {
    
    public var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    public var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
