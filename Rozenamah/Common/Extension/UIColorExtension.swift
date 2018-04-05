//
//  UIColorExtesion.swift
//  Rozenamah
//
//  Created by Dominik Majda on 13.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var rmRed: UIColor {
        return UIColor(r: 208, g: 2, b: 27)
    }
    
    static var rmGray: UIColor {
        return UIColor(r: 138, g: 138, b: 138)
    }
    
    static var rmBlue: UIColor {
        return UIColor(r: 91, g: 192, b: 208)
    }
    
    static var rmPale: UIColor {
        return UIColor(r: 224, g: 231, b: 238)
    }
    
    static var rmShadow: UIColor {
        return UIColor(r: 140, g: 140, b: 140)
    }
}
