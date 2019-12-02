//
//  PhoneCallRouter.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 16.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PhoneCallRouter {
    func makeCall(to phoneNumber: String)
}

extension PhoneCallRouter where Self: Router {
    
    func makeCall(to phoneNumber: String) {
        let str = "tel://\(phoneNumber)"
        guard let number = URL(string: str) else { return }
        UIApplication.shared.open(number)
    }
}
