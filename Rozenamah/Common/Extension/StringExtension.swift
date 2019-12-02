//
//  StringExtension.swift
//  Rozenamah
//
//  Created by Piotr Soboń on 31.08.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

extension String {
    var localizedError: String? {
        guard "errors.\(self)".localized != "errors.\(self)" else { return nil }
        return "errors.\(self)".localized
    }
}
