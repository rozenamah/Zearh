//
//	PaymentProfileModels.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

enum PaymentProfile {
    enum ValidateForm {
        struct Request {
            var addressLine1: String?
            var addressLine2: String?
            var state: String?
            var city: String?
            var postalCode: String?
            var country: String?
            var language: String?
            
            init() {}
        }
    }
    class Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case url = "link"
        }
        let url: String
    }
}
