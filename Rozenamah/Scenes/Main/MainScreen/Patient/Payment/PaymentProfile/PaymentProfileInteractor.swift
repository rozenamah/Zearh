//
//	PaymentProfileInteractor.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PaymentProfileBusinessLogic {
    func actionWithForm(request: PaymentProfile.ValidateForm.Request)
}

protocol PaymentProfileDataStore {
    var webViewURL: String {get set}
}

class PaymentProfileInteractor: PaymentProfileBusinessLogic, PaymentProfileDataStore {

	// MARK: - Properties
    
    var webViewURL: String = ""
	var presenter: PaymentProfilePresentationLogic?
	var worker = PaymentProfileWorker()
	
	// MARK: - Business Logic
    
    func actionWithForm(request: PaymentProfile.ValidateForm.Request) {
        guard let request = validateFormWith(request: request) else {
            return
        }
        worker.sendPaymentProfileDetailsWith(request: request, completion: { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let response = response {
                self.webViewURL = response.url
                self.presenter?.presentWebView()
            }
        })
    }
    
    private func validateFormWith(request: PaymentProfile.ValidateForm.Request) -> (PaymentProfileWorker.Request)? {
        var areFieldsValidated = true
        
        if request.addressLine1 == "" {
            presenter?.presentValidationError(error: .emptyAddress)
            areFieldsValidated = false
        }
        if request.state == "" {
            presenter?.presentValidationError(error: .emptyState)
            areFieldsValidated = false
        }
        if request.city == "" {
            presenter?.presentValidationError(error: .emptyCity)
            areFieldsValidated = false
        }
        if request.postalCode == "" {
            presenter?.presentValidationError(error: .emptyPostalCode)
            areFieldsValidated = false
        }
        if request.country == "" {
            presenter?.presentValidationError(error: .emptyCountry)
            areFieldsValidated = false
        }
        if areFieldsValidated {
            let request = PaymentProfileWorker.Request(address: "\(request.addressLine1!)\(request.addressLine2 ?? "")",
                                                              state: "\(request.state!)",
                                                              city: "\(request.city!)",
                                                              postalCode: "\(request.postalCode!)",
                                                              country: "\(request.country!)",
                                                              language: "\(request.language)")
            return (request)
        } else {
            return nil
        }
    }
	
}
