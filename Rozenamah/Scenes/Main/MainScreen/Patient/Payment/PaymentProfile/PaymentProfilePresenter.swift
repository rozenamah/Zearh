//
//	PaymentProfilePresenter.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

protocol PaymentProfilePresentationLogic {
    func presentValidationError(error: PaymentProfilePresenter.PaymentValidationError)
    func handleError(_ error: RMError)
    func presentWebView()
}

class PaymentProfilePresenter: PaymentProfilePresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: PaymentProfileDisplayLogic?
    
    // MARK: - Presentation Logic
    
    enum PaymentValidationError: LocalizedError {
        case emptyAddress
        case emptyState
        case emptyCity
        case emptyPostalCode
        case emptyCountry
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .emptyAddress:
                return "payment.error.address".localized
            case .emptyCity:
                return "payment.error.city".localized
            case .emptyCountry:
                return "payment.error.country".localized
            case .emptyPostalCode:
                return "payment.error.postalCode".localized
            case .emptyState:
                return "payment.error.state".localized
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "generic.error.unknown".localized
            }
        }
    }
    
    func presentValidationError(error: PaymentProfilePresenter.PaymentValidationError) {
        viewController?.displayPaymentValidationError(error: error)
    }
    
    func handleError(_ error: RMError) {
        switch error {
        case .unknown(let error):
            viewController?.displayError(error: error)
        default:
            presentValidationError(error: .unknown(error))
        }
    }
    
    func presentWebView() {
        viewController?.displayWebView()
    }
    
}
