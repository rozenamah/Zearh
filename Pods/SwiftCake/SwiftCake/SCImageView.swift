//
//  SCImageView.swift
//  SwiftCake
//
//  Created by Dominik Majda on 23.02.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

@IBDesignable
open class SCImageView: UIImageView, SCRoundedBorderedView {
    
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
    
    
}
