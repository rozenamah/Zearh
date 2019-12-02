//
//  RMTextFieldWithError.swift
//  Rozenamah
//
//  Created by Dominik Majda on 13.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

class RMTextFieldWithError: UIView {
    
    enum FieldState {
        case active
        case inactive
        case error(msg: Error)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    private var currentState: FieldState = .inactive
    
    func adjustToState(_ state: FieldState) {
        switch state {
        case .active:
            errorLabel.isHidden = true
            separatorView.backgroundColor =  UIColor.rmBlue
        case .inactive:
            // If we want to mark as inactive and there is error remaining - break
            if case .error(_) = currentState {
                break
            }
            errorLabel.isHidden = true
            separatorView.backgroundColor =  UIColor.rmGray
        case .error(let msg):
            errorLabel.isHidden = false
            errorLabel.text = msg.localizedDescription
            separatorView.backgroundColor =  UIColor.rmRed
        }
        currentState = state
    }
    
}
