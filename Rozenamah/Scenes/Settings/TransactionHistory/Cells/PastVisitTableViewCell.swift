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
    
    // MARK: Properties
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isRTL() {
            // If arabic language use reversed arrow
            arrowImage.image = UIImage(named: "reversed_chevron")
            // Move image to the right, beacuse is to close to the arrow
            imageViewLeftConstraint.constant = 24
        }
    }
}
