//
//	PaymentProfileViewController.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake

protocol PaymentProfileDisplayLogic: class {
    func displayPaymentValidationError(error: PaymentProfilePresenter.PaymentValidationError)
    func displayError(error: Error)
    func displayWebView()
    func displayWaitAlert()
    func displayPaymentProfile(profile: Payment.Details)
}

class PaymentProfileViewController: UIViewController, PaymentProfileDisplayLogic {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLine1View: RMTextFieldWithError!
    @IBOutlet weak var stateView: RMTextFieldWithError!
    @IBOutlet weak var cityView: RMTextFieldWithError!
    @IBOutlet weak var postalCodeView: RMTextFieldWithError!
    @IBOutlet weak var countryView: RMTextFieldWithError!
    @IBOutlet weak var confirmButton: SCButton!
    @IBOutlet var textfieldCollection: [SCTextField]!
    
	// MARK: - Properties

	var interactor: PaymentProfileBusinessLogic?
	var router: (NSObjectProtocol & PaymentProfileRoutingLogic & PaymentProfileDataPassing)?
    private var request = PaymentProfile.ValidateForm.Request()

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
        interactor?.prepareFieldsIfPossible()
	}

    // MARK: - Private
    
    private func setupView() {
        // Customize button insets depedning on layout direction
        if self.view.isRTL() {
            // Set text input from right if arabic language
            textfieldCollection.forEach({ $0.textAlignment = .right })
        }
    }
    
	// MARK: - Display Logic
    
    func displayPaymentValidationError(error: PaymentProfilePresenter.PaymentValidationError) {
        router?.hideWaitAlert { [weak self] in
            switch error {
            case .emptyAddress:
                self?.addressLine1View.adjustToState(.error(msg: error))
            case .emptyCity:
                self?.cityView.adjustToState(.error(msg: error))
            case .emptyCountry:
                self?.countryView.adjustToState(.error(msg: error))
            case .emptyPostalCode:
                self?.postalCodeView.adjustToState(.error(msg: error))
            case .emptyState:
                self?.stateView.adjustToState(.error(msg: error))
            default:
                self?.router?.showError(error)
            }
        }
    }
    
    func displayError(error: Error) {
        router?.hideWaitAlert { [weak self] in
            self?.router?.showError(error)
        }
    }
    
    func displayWebView() {
        router?.hideWaitAlert { [weak self] in
            self?.router?.navigateToPaymentWebViewController()
        }
    }
    
    func displayWaitAlert() {
        router?.showWaitAlert()
    }
    
    func displayPaymentProfile(profile: Payment.Details) {
        addressLine1View.textField.text = profile.billingAddress
        stateView.textField.text = profile.state
        cityView.textField.text = profile.city
        postalCodeView.textField.text = profile.postalCode
        countryView.textField.text = profile.country
    }
    
    // MARK: - Actions
    
    @IBAction func confirmPressed(_ sender: SCButton) {
        request.addressLine1 = addressLine1View.textField.text
        request.state = stateView.textField.text
        request.city = cityView.textField.text
        request.postalCode = postalCodeView.textField.text
        request.country = countryView.textField.text
        if self.view.isRTL() {
            request.language = "Arabic"
        } else {
            request.language = "English"
        }
        interactor?.actionWithForm(request: request)
    }
    
}

extension PaymentProfileViewController: UITextFieldDelegate {
    
    @IBAction func textChanged(_ textField: UITextField) {
        textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case addressLine1View.textField:
            addressLine1View.adjustToState(.active)
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

