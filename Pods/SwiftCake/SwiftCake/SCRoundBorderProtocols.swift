//
//  SKRoundBorderProtocols.swift
//  SwiftCake
//
//  Created by Dominik Majda on 23.02.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

public protocol SCRoundedBorderedView: SCRoundedView, SCBorderedView {
    
}

public protocol SCRoundedView {
    var cornerRadius: CGFloat { set get }
    var masksToBounds: Bool { set get }
}

public protocol SCBorderedView {
    var borderWidth: CGFloat { set get }
    var borderColor: UIColor { set get }
}

extension SCBorderedView where Self: UIView {
    
    func updateBorderColor(with value: UIColor) {
        self.layer.borderColor = value.cgColor
    }
    
    
    func updateBorderWidth(with value: CGFloat) {
        self.layer.borderWidth = value
    }
    
}

extension SCRoundedView where Self: UIView {
    
    func updateMasksToBounds(with value: Bool) {
        self.layer.masksToBounds = value
    }
    
    func updateCornerRadius(with value: CGFloat) {
        self.layer.cornerRadius = value
        if value>0 {
            self.layer.masksToBounds = true
        }
    }
    
}
