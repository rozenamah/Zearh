//
//  iPhoneDeviceDetection.swift
//  Rozenamah
//
//  Created by Dominik Majda on 20.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

class iPhoneDetection {
    
    enum iPhone {
        case iphone3
        case iphone4
        case iphone5
        case iphone6
        case iphonePlus
        case iphoneX
        case unknown
    }
    
    static func deviceType() -> iPhone {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                return .iphone3
            case 960:
                return .iphone4
            case 1136:
                return .iphone5
            case 1334:
                return .iphone6
            case 2208:
                return .iphonePlus
            case 2436:
                return .iphoneX
            default:
                return .unknown
            }
        }
        return .unknown
    }
    
}
