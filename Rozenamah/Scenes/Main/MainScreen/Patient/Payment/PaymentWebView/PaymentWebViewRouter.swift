//
//	PaymentWebViewRouter.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

@objc protocol PaymentWebViewRoutingLogic {
    func showLoadingAlert()
    func dismissLoadingAlert(completion: @escaping () -> ())
}

protocol PaymentWebViewDataPassing {
	var dataStore: PaymentWebViewDataStore? { get }
}

class PaymentWebViewRouter: NSObject, AlertRouter, Router, PaymentWebViewRoutingLogic, PaymentWebViewDataPassing {
    
    private var alertLoading: UIAlertController?
    
    func showLoadingAlert() {
        alertLoading = showLoadingAlert()
    }
    
    func dismissLoadingAlert(completion: @escaping () -> ()) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
    

	// MARK: - Properties

	weak var viewController: PaymentWebViewViewController?
	var dataStore: PaymentWebViewDataStore?
	
	// MARK: - Routing
	
}
