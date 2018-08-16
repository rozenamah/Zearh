//
//	PaymentWebViewRouter.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

@objc protocol PaymentWebViewRoutingLogic {}

protocol PaymentWebViewDataPassing {
	var dataStore: PaymentWebViewDataStore? { get }
}

class PaymentWebViewRouter: NSObject, PaymentWebViewRoutingLogic, PaymentWebViewDataPassing {

	// MARK: - Properties

	weak var viewController: PaymentWebViewViewController?
	var dataStore: PaymentWebViewDataStore?
	
	// MARK: - Routing
	
}
