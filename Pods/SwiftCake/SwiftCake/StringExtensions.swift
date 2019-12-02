//
//  StringExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 09.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import Foundation

public enum StringAttrs {
    case kerning
}

//extension String {
//    
//    public func add(attr: StringAttrs, value: CGFloat) -> NSAttributedString {
//        switch attr {
//        case .kerning:
//            return kerning(value: value)
//        }
//    }
//    
//    fileprivate func kerning(value: CGFloat = 3.0) -> NSAttributedString {
//        let kerningString = NSMutableAttributedString(
//            string: self)
//        return kerningString.kerning(value: value)
//    }
//    
//    
//}
//
//extension NSMutableAttributedString {
//    
//    public func add(attr: StringAttrs, value: CGFloat) -> NSAttributedString {
//        switch attr {
//        case .kerning:
//            return kerning(value: value)
//        }
//    }
//    
//    
//    fileprivate func kerning(value: CGFloat = 3.0) {
//      
//        self.addAttribute(NSKernAttributeName,
//                                   value: value,
//                                   range: NSMakeRange(0, self.length))
//        
//    }
//    
//    
//}

