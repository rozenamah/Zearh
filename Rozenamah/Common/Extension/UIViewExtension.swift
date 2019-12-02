//
//  UIViewExtension.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 18.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import Localize

extension UIView {
    func isRTL() -> Bool {
      return Localize.shared.currentLanguage == "ar"
    }
}


func isValid1(paymentStatus: String) -> Bool {
    let PHONE_REGEX = "^(000\\.000\\.|000\\.100\\.1|000\\.[36])"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: paymentStatus)
    return result
}

func isValid2(paymentStatus: String) -> Bool {
    let PHONE_REGEX = "^(000\\.400\\.0[^3]|000\\.400\\.100)"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: paymentStatus)
    return result
}
