//
//	PaymentWebViewInteractor.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PaymentWebViewBusinessLogic {}

protocol PaymentWebViewDataStore {
    var webViewURL: String! {get set}
}

class PaymentWebViewInteractor: PaymentWebViewBusinessLogic, PaymentWebViewDataStore {

	// MARK: - Properties

	var presenter: PaymentWebViewPresentationLogic?
	var worker: PaymentWebViewWorker?
	
	// MARK: - Business Logic
    
    var webViewURL: String!
	
}
