//
//  ModalInformationViewController.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 26.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake


class ModalInformationViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: SCImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    // MARK: Properties
    
    // View customization
    
    func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails) {
        let cost = visitInfo.cost
        
        avatarImage.setAvatar(for: user)
        nameLabel.text = user.fullname
        priceLabel.text = "\(cost.price) SAR"
        phoneNumber.setTitle(user.phone ?? "No phone number", for: .normal)
        
        // Without this phone number will rever title to previous one (it is a bug but source is uknown)
        phoneNumber.setTitle(user.phone ?? "No phone number", for: .highlighted)
        distanceButton?.setTitle("\(visitInfo.distanceInKM) km from you", for: .highlighted)
        
        // If more then 10 kilometers, highlight distance to red
        distanceButton?.tintColor = visitInfo.distanceInKM > 10 ? .rmRed : .rmGray
        
        // If fee > 0, show fee label
        feeLabel.isHidden = cost.fee <= 0
        feeLabel.text = "+ \(cost.fee) SAR for cancellation"
        
    }
}
