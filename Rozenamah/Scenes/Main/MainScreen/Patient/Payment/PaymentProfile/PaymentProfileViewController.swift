//
//	PaymentProfileViewController.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake

protocol PaymentProfileDisplayLogic: class {}

class PaymentProfileViewController: UIViewController, PaymentProfileDisplayLogic {
    
    enum Field {
        case addressLine1
        case addressLine2
        case state
        case city
        case postalCode
        case country
    }

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLine1View: RMTextFieldWithError!
    @IBOutlet weak var addressLine2View: RMTextFieldWithError!
    @IBOutlet weak var stateView: RMTextFieldWithError!
    @IBOutlet weak var cityView: RMTextFieldWithError!
    @IBOutlet weak var postalCodeView: RMTextFieldWithError!
    @IBOutlet weak var countryView: RMTextFieldWithError!
    @IBOutlet weak var confirmButton: SCButton!
    @IBOutlet var textfieldCollection: [SCTextField]!
    
	// MARK: - Properties

	var interactor: PaymentProfileBusinessLogic?
	var router: (NSObjectProtocol & PaymentProfileRoutingLogic & PaymentProfileDataPassing)?

	// MARK: - Initialization
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	// MARK: - Setup
	
	private func setup() {
		let viewController = self
		let interactor = PaymentProfileInteractor()
		let presenter = PaymentProfilePresenter()
		let router = PaymentProfileRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
	// MARK: - Routing
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Display Logic
    
    fileprivate func setupView() {
        // Customize button insets depedning on layout direction
        if self.view.isRTL() {
            // Set text input from right if arabic language
            textfieldCollection.forEach({ $0.textAlignment = .right })
        }
    }
	
}

extension PaymentProfileViewController: UITextFieldDelegate {
    
    @IBAction func textChanged(_ textField: UITextField) {
//        switch textField {
//        case addressLine1View.textField:
//            registerForm.email = textField.text
//        case passwordView.textField:
//            registerForm.password = textField.text
//        case nameView.textField:
//            registerForm.name = textField.text
//        case surnameView.textField:
//            registerForm.surname = textField.text
//        case confirmPasswordView.textField:
//            registerForm.repeatPassword = textField.text
//        case phoneView.textField:
//            registerForm.phone = textField.text
//        default:
//            break
//        }
        textFieldDidBeginEditing(textField) // To mark as active
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case addressLine1View.textField:
            addressLine1View.adjustToState(.active)
        case addressLine2View.textField:
            addressLine2View.adjustToState(.active)
        case stateView.textField:
            stateView.adjustToState(.active)
        case cityView.textField:
            cityView.adjustToState(.active)
        case postalCodeView.textField:
            postalCodeView.adjustToState(.active)
        case countryView.textField:
            countryView.adjustToState(.active)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case addressLine1View.textField:
            addressLine1View.adjustToState(.inactive)
        case addressLine2View.textField:
            addressLine2View.adjustToState(.inactive)
        case stateView.textField:
            stateView.adjustToState(.inactive)
        case cityView.textField:
            cityView.adjustToState(.inactive)
        case postalCodeView.textField:
            postalCodeView.adjustToState(.inactive)
        case countryView.textField:
            countryView.adjustToState(.inactive)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case addressLine1View.textField:
            addressLine2View.textField.becomeFirstResponder()
            return false
        case addressLine2View.textField:
            stateView.textField.becomeFirstResponder()
            return false
        case stateView.textField:
            cityView.textField.becomeFirstResponder()
            return false
        case cityView.textField:
            postalCodeView.textField.becomeFirstResponder()
            return false
        case postalCodeView.textField:
            countryView.textField.becomeFirstResponder()
            return false
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}

