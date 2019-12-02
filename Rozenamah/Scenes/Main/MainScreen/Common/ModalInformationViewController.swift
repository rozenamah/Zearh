//
//  ModalInformationViewController.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 26.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake

class BasicModalInformationViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: SCImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    
    // MARK: View customization
    func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails, withAddress address: String?) {
        let cost = visitInfo.cost
        
        avatarImage.setAvatar(for: user)
        nameLabel.text = user.fullname
        priceLabel.text = "\(cost.price) SAR"
              
        // If fee > 0, show fee label
        feeLabel.isHidden = cost.fee <= 0
        feeLabel.text = cost.fee <= 0 ? "" : "+ \(cost.fee) SAR \("settings.transactionHistory.feeInfo".localized)"
    }
}

class ModalInformationViewController: BasicModalInformationViewController {
    
    //MARK: Outlets
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    // MARK: Properties
    
    // MARK: View customization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.isRTL() {
            distanceButton?.contentHorizontalAlignment = .right
            distanceButton?.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16)
            distanceButton?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16)
            phoneNumber?.contentHorizontalAlignment = .right
            phoneNumber?.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16)
            phoneNumber?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16)
        }
    }
    
    override func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails, withAddress address: String?) {
        super.fillInformation(with: user, andVisitInfo: visitInfo, withAddress: address)
        
        phoneNumber.setTitle(user.phone ?? "errors.noPhoneNumber".localized, for: .normal)
        
        // Without this phone number will revet title to previous one (it is a bug but source is uknown)
        phoneNumber.setTitle(user.phone ?? "errors.noPhoneNumber".localized, for: .highlighted)
        
        // Depending on this value we set distance to user or his exact location
        if let address = address {
            //newDistance
            distanceButton?.setTitle("\(address) \n\(visitInfo.distanceInKM) \("alerts.distanceFromYou".localized)", for: .normal)
//            distanceButton?.setTitle("\(address) \n\(visitInfo.distanceInKM) \("alerts.distanceFromYou".localized)", for: .highlighted)
            distanceButton?.tintColor = .rmGray
        } else {
            distanceButton?.setTitle("\(visitInfo.distanceInKM) \("alerts.distanceFromYou".localized)", for: .normal)
//            distanceButton?.setTitle("\(visitInfo.distanceInKM) \("alerts.distanceFromYou".localized)", for: .highlighted)
            // If more then 10 kilometers, highlight distance to red
            distanceButton?.tintColor = visitInfo.distanceInKM > 10 ? .rmRed : .rmGray
        }
        
    }
}
