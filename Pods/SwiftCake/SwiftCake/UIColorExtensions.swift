//
//  UIColorExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 07.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Use this method to convert values from range 0..255 to UIColor
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
    
    /// Use this method to convert color hash in form of ffffff or #ffffff to convert it to UIColor
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
