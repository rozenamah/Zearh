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
            let addressLine1: String?
            let addressLine2: String?
            let state: String?
            let city: String?
            let postalCode: String?
            let country: String?
            let language: String
        }
    }
    class Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case url = "link"
        }
        let url: String
    }
}
