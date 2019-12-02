//
//  SCLabel.swift
//  SwiftCake
//
//  Created by Dominik Majda on 09.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

@IBDesignable
open class SCLabel: UILabel, SCRoundedBorderedView {
    
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

@IBDesignable
open class SCAttrLabel: SCLabel {
    
    fileprivate var defaultParagraphLineSpacing: CGFloat = 0
    @IBInspectable open var paragraphLineSpacing: CGFloat {
        get {
            return defaultParagraphLineSpacing
        }
        set {
            self.defaultParagraphLineSpacing = newValue
            if let text = self.text { // Refresh text
                self.text = text
            }
        }
    }
    fileprivate var defaultKerning: CGFloat = 0
    @IBInspectable open var kerning: CGFloat {
        get {
            return defaultKerning
        }
        set {
            self.defaultKerning = newValue
            if let text = self.text { // Refresh text
                self.text = text
            }
        }
    }
    
    override open var text: String? {

        set(text) {
            guard let text = text else {
                self.attributedText = nil
                return
            }

            let attributeString = NSMutableAttributedString(string: text)
            self.attributedText = attributeString
        }

        get {
            return super.attributedText?.string
        }

    }

    override open var attributedText: NSAttributedString? {

        set(attributedText) {

            guard let attributedText = attributedText else {
                super.attributedText = nil
                return
            }

            let attributeString = NSMutableAttributedString(attributedString: attributedText)
            
            // Add line spacing
            if self.paragraphLineSpacing > 0 {
                let style = NSMutableParagraphStyle()
                style.lineSpacing = paragraphLineSpacing
                style.alignment = self.textAlignment
                attributeString.addAttribute(.paragraphStyle,
                                             value: style,
                                             range: NSMakeRange(0, attributedText.length))
            }
            
            // Add kerning
            if self.kerning > 0 {
                attributeString.addAttribute(.kern,
                                             value: kerning,
                                             range: NSMakeRange(0, attributedText.length))
            }
            
            super.attributedText = attributeString
            
        }
        
        get {
            return super.attributedText
        }
        
    }
    
    
    
}
