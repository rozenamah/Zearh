//
//  KingfisherExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 22.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import KeychainAccess
import Kingfisher

extension UIImageView {
    
    func setAvatar(for profile: User?) {
        
        // To see image you need to be verified, so we add autorization token
        let modifier = AnyModifier { request in
            
            var r = request
            guard let token = Keychain.shared.token else {
                return r
            }
            // replace "Access-Token" with the field name you need, it's just an example
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return r
        }
        
        if let profile = profile {
            kf.setImage(with: profile.avatarURL, placeholder: UIImage(named: "placeholder_big"), options: [.requestModifier(modifier), ])
            return
        }
        kf.setImage(with: nil, placeholder: nil)
    }
    
}
