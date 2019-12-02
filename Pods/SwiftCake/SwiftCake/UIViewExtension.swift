//
//  UIViewExtension.swift
//  SwiftCake
//
//  Created by Dominik Majda on 26.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /// Returns view class with nib loaded from file with the same name
    ///
    /// - Returns: class with all outlets and view set
    public class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self),
                                        owner: nil,
                                        options: nil)![0] as! T
    }
}
