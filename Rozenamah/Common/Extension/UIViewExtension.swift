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
