//
//  SummaryTableViewCell.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 09.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake

class SummaryTableViewCell: UITableViewCell, SCReusableCell {
    
    // MARK: Outlets
    @IBOutlet weak var visitsNumberLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    
    // MARK: Properties
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.isRTL() {
            paymentAmountLabel.textAlignment = .left
        }
    }
}
