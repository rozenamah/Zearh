//
//  SCNavigationBar.swift
//  SwiftCake
//
//  Created by Dominik Majda on 07.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

@IBDesignable
public class SCNavigationBar: UINavigationBar {
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            createBottomBorder(color: borderColor)
        }
    }
    
    @IBInspectable open var transparentBar: Bool = false {
        didSet {
            if transparentBar {
                makeTransparentBar()
            } else {
                restoreNormalBar()
            }
        }
    }
    
    fileprivate func restoreNormalBar() {
        self.setBackgroundImage(
            UINavigationBar.appearance().backgroundImage(for: .default),
            for: .default)
        self.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    fileprivate func makeTransparentBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    fileprivate func createBottomBorder(color: UIColor) {

        let bottomBorderView = UIView(frame: CGRect.zero)
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = color
        
        self.addSubview(bottomBorderView)
        
        let views = ["border": bottomBorderView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[border]|", options: [], metrics: nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.5))
        self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        
    }
    
}
