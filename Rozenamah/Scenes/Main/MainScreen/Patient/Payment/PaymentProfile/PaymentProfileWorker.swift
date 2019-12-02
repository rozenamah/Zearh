//
//	PaymentProfileWorker.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

typealias PaymentCompletion = (PaymentProfile.Response?, RMError?) -> Void

class PaymentProfileWorker {
    
    private let splashWorker = SplashWorker()
    
    struct Request {
        let address: String
        let state: String
        let city: String
        let postalCode: String
        let country: String
        let language: String
    }
    
    func sendPaymentProfileDetailsWith(request: PaymentProfileWorker.Request, completion: @escaping PaymentCompletion) {
        var params = [
            "billing_address": request.address,
            "state": request.state,
            "city": request.city,
            "postal_code": request.postalCode,
            "country": request.country,
            "msg_lang": request.language
        ]
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        //old payment method and api commented by Najam
//        splashWorker.fetchMyBooking(completion: { (booking, error) in
//            if let fetchedBooking = booking {
//                params["visit"] = fetchedBooking.id
//                Alamofire.request(API.Payments.paypage.path, method: .post, parameters: params,
//                                  encoding: JSONEncoding.default, headers: headers)
//                    .validate()
//                    .responseCodable(type: PaymentProfile.Response.self, completion: completion)
//            }
//        })
        
        // newCode added by Najam hyperpay and new api
        splashWorker.fetchMyBooking(completion: { (booking, error) in
            if let fetchedBooking = booking {
                params["visit"] = fetchedBooking.id
                Alamofire.request(API.Payments.confirm.path, method: .post, parameters: params,
                                  encoding: JSONEncoding.default, headers: headers)
                    .validate()
                    .responseCodable(type: PaymentProfile.Response.self, completion: completion)
            }
        })
        
    }
    
}
