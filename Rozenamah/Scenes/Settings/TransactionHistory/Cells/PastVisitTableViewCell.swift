//
//  ProfileTableViewCell.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 09.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake

class PastVisitTableViewCell: UITableViewCell, SCReusableCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImaveView: SCImageView!
    
    // MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isRTL() {
            // If arabic language use reversed arrow
            arrowImage.image = UIImage(named: "reversed_chevron")
            // Move image to the right, beacuse is to close to the arrow
            imageViewLeftConstraint.constant = 24
        }
    }
    
    // MARK: Properties
    
    /// By this value we know if we should display doctor or patient
    var currentMode: UserType!
    
    var booking: Booking? {
        didSet {
            if let booking = booking {
                let cost = booking.visit.cost
                nameLabel.text = currentMode != .patient ? booking.patient.fullname : booking.visit.user.fullname
                specialistLabel.isHidden = currentMode != .patient
                specialistLabel.text = booking.visit.user.doctor?.specialization?.title
                addressLabel.text = booking.address ?? "errors.unknownAddress".localized
                priceLabel.text = "\(cost.price) SAR"
                feeLabel.isHidden = cost.fee <= 0
                feeLabel.text = "+ \(cost.fee) SAR \("settings.transactionHistory.feeInfo".localized)"
                dateLabel.text = booking.dates?.requestedAt?.printer.string(with: DateFormats.day.rawValue) ?? "errors.unknownDate".localized
                
                avatarImaveView.setAvatar(for: currentMode != .patient ? booking.patient : booking.visit.user)
            }
        }
    }
}
