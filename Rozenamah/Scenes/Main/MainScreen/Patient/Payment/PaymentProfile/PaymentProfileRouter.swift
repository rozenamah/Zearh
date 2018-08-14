//
//	PaymentProfileRouter.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

@objc protocol PaymentProfileRoutingLogic {}

protocol PaymentProfileDataPassing {
	var dataStore: PaymentProfileDataStore? { get }
}

class PaymentProfileRouter: NSObject, PaymentProfileRoutingLogic, PaymentProfileDataPassing {

	// MARK: - Properties

	weak var viewController: PaymentProfileViewController?
	var dataStore: PaymentProfileDataStore?
	
	// MARK: - Routing
	
}
