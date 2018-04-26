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
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    // MARK: Properties
    
    var visitInfo: VisitDetails! {
        didSet {
            fillInformation()
        }
    }
    
    // View customization
    func fillInformation() {
        let user = visitInfo.user
        let visit = visitInfo.visit
        avatarImage.setAvatar(for: user)
        nameLabel.text = user.fullname
        priceLabel.text = "\(visit.price) SAR"
        phoneNumber.setTitle(visit.phone ?? "No phone number", for: .normal)
        distanceButton.setTitle("\(visit.distanceInKM) km from you", for: .normal)
        
        // Without this phone number will rever title to previous one (it is a bug but source is uknown)
        phoneNumber.setTitle(visit.phone ?? "No phone number", for: .highlighted)
        distanceButton.setTitle("\(visit.distanceInKM) km from you", for: .highlighted)
        
        // If more then 10 kilometers, highlight distance to red
        distanceButton.tintColor = visit.distanceInKM > 10 ? .rmRed : .rmGray
        
        // If fee > 0, show fee label
        feeLabel.isHidden = visit.fee <= 0
        feeLabel.text = "+ \(visit.fee) SAR for cancellation"
        
    }
}
