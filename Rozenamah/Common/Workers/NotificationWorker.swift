//
//  NotificationWorker.swift
//  Rozenamah
//
//  Created by Dominik Majda on 29.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

class NotificationWorker {
    
    func saveDeviceToken(inData deviceToken: Data, completion: @escaping ErrorCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let deviceToken = tokenParts.joined()
        let params = [
            "type": "ios",
            "device_token": deviceToken
        ]
        
        // Save device token - we will use it during logout
        Settings.shared.deviceToken = deviceToken
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.devices.path, method: .post,
                          parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
        
    }
    
}
