//
//  SCView.swift
//  SwiftCake
//
//  Created by Dominik Majda on 25.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
open class SCView: UIView, SCRoundedBorderedView {
    
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius(with: cornerRadius)
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            updateBorderWidth(with: borderWidth)
        }
    }
    
    @IBInspectable open var masksToBounds: Bool = false {
        didSet {
            updateMasksToBounds(with: masksToBounds)
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            updateBorderColor(with: borderColor)
        }
    }
    
    
}
