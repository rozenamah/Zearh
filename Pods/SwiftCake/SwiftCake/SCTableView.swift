//
//  SCTableView.swift
//  SwiftCake
//
//  Created by Dominik Majda on 20.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

public class SCStateTableViewSettings {
    
    static var infoLabelFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    static var activityIndicatorStyle: UIActivityIndicatorViewStyle = .gray
    
    
}

@IBDesignable
public class SCStateTableView: UITableView {
    
    // Views
    public let infoLabel = SCAttrLabel()
    public let activityIndicator = UIActivityIndicatorView()
    
    // Default messages
    fileprivate var _initialMessage: String?
    @IBInspectable public var initialMessage: String? {
        didSet {
            _initialMessage = initialMessage
        }
    }
    fileprivate var _noItemsMessage: String?
    @IBInspectable public var noItemsMessage: String? {
        didSet {
            _noItemsMessage = noItemsMessage
        }
    }
    
    
    // Updating content insets
    fileprivate var heightConstraints = [NSLayoutConstraint]()
    public override var contentInset: UIEdgeInsets {
        didSet {
            super.contentInset = contentInset
            
            // Update constraints
            heightConstraints.forEach { (constraint) in
                constraint.constant = -(contentInset.top)
            }
        }
    }
    
    // State
    public enum TableViewState {
        case loading
        case showItems
        case noItems
        case initial
    }
    public var state: TableViewState {
        didSet {
            adoptToState(state)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        state = .initial
        super.init(coder: aDecoder)
        addComponents()
        adoptToState(.loading)
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        state = .initial
        super.init(frame: frame, style: style)
        addComponents()
        adoptToState(.loading)
    }
    
    fileprivate func adoptToState(_ state: TableViewState) {
        switch state {
        case .loading:
            infoLabel.isHidden = true
            activityIndicator.startAnimating()
        case .noItems:
            infoLabel.isHidden = false
            infoLabel.text = self._noItemsMessage
            activityIndicator.stopAnimating()
        case .showItems:
            infoLabel.isHidden = true
            activityIndicator.stopAnimating()
        case .initial:
            infoLabel.isHidden = false
            infoLabel.text = self._initialMessage
            activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func addComponents() {
        
        // Configure activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = SCStateTableViewSettings.activityIndicatorStyle
        
        // Configure info label
        infoLabel.isHidden = true
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = SCStateTableViewSettings.infoLabelFont
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = UIColor.lightGray
        
        // Add views to table view
        addSubview(activityIndicator)
        addSubview(infoLabel)
        
        // Construct center constraints
        addConstraint(NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        let constraintLabel = NSLayoutConstraint(item: infoLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        heightConstraints.append(constraintLabel)
        addConstraint(constraintLabel)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        let constraintActivity = NSLayoutConstraint(item: self.activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        heightConstraints.append(constraintActivity)
        addConstraint(constraintActivity)
        
    }
    
}
