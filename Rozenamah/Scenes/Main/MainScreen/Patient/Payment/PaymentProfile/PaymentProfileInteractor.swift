//
//	PaymentProfileInteractor.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PaymentProfileBusinessLogic {}

protocol PaymentProfileDataStore {}

class PaymentProfileInteractor: PaymentProfileBusinessLogic, PaymentProfileDataStore {

	// MARK: - Properties

	var presenter: PaymentProfilePresentationLogic?
	var worker: PaymentProfileWorker?
	
	// MARK: - Business Logic
	
}
