//
//  KingfisherExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 22.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setAvatar(for profile: User?) {
        if let profile = profile {
            kf.setImage(with: profile.avatarURL, placeholder: UIImage(named: "placeholder_big"))
            return
        }
        kf.setImage(with: nil, placeholder: nil)
    }
    
}
