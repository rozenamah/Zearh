//
//  UIButtonExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 19.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var automaticallyAdjustFont: Bool {
        get {
            if #available(iOS 10, *) {
                return titleLabel?.adjustsFontForContentSizeCategory ?? false
            }
            return false
        }
        set {
            if #available(iOS 10, *) {
                titleLabel?.adjustsFontForContentSizeCategory = newValue
            }
        }
    }
    
}
