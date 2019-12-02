//
//  SCTextField.swift
//  SwiftCake
//
//  Created by Dominik Majda on 07.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

@IBDesignable
open class SCTextField: UITextField, SCRoundedBorderedView {
    
    @IBInspectable open var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
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
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            updateBorderColor(with: borderColor)
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor {
        get {
            return self.value(forKeyPath: "_placeholderLabel.textColor") as? UIColor ?? .clear
        }
        set {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    
}
