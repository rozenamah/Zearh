//
//	PaymentProfileViewController.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit
import SwiftCake
import RappleProgressHUD
import CountryPicker

protocol PaymentProfileDelegate {
    func paymentSuccess()
}
protocol PaymentProfileDisplayLogic: class {
    func displayPaymentValidationError(error: PaymentProfilePresenter.PaymentValidationError)
    func displayError(error: Error)
    func displayWebView()
    func displayWaitAlert()
    func displayPaymentProfile(profile: Payment.Details)
}

class PaymentProfileViewController: UIViewController, PaymentProfileDisplayLogic {

    // MARK: - Outlets
    
    @IBOutlet weak var picker: CountryPicker!
    
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

    
    //Added by Hassan Bhatti
    var presenter: PaymentProfilePresentationLogic?
    var worker = PaymentProfileWorker()
//    private var paymentMethod: PaymentMethod?
//    var doctor: VisitDetails!
    var booking: Booking!
    
    var delegate: PaymentProfileDelegate?
    
    //END
    
    // MARK: For Payments
    //Added By Hassan Bhatti
    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    //END
    
	// MARK: - Initialization
    var checkoutID = ""
	
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
        
        //set CountryView picker
        //get current country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        //        picker.displayOnlyCountriesWithCodes = ["DK", "SE", "NO", "DE"] //display only
        //        picker.exeptCountriesWithCodes = ["PK"] //exept country
        //        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)        //optional for UIPickerView theme changes
        //        picker.theme = theme //optional for UIPickerView theme changes
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = false
        picker.setCountry("SA")
	}
    
    
    @IBAction func btnPickCountry_Tapped(_ sender: Any) {
        
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
                self?.router?.showError(error, sender: self!.view)
            }
        }
    }
    
    func displayError(error: Error) {
        router?.hideWaitAlert { [weak self] in
            self?.router?.showError(error, sender: self!.view)
        }
    }
    
    func displayWebView() {
        router?.hideWaitAlert { [weak self] in
            self?.router?.navigateToPaymentWebViewController()
        }
    }
    
    func displayWaitAlert() {
        router?.showWaitAlert(sender: self.view)
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
//        interactor?.actionWithForm(request: request) //Commented by Hassan Bhatti
        //Added by Hassan Bhatti
        self.actionWithForm(request: request)
    }
    
    //Added by Hassan Bhatti
    func actionWithForm(request: PaymentProfile.ValidateForm.Request) {
        guard let _ = validateFormWith(request: request) else {
            return
        }
        self.displayWaitAlert()
        
//        Request.requestCheckoutID(amount: Double(booking.visit.cost.total), currency: Config.currency, completion: {(checkoutID) in
        Request.newRequestCheckoutID(amount: Double(booking.visit.cost.total), transID: "111", firstName: User.current!.name, lastName: User.current!.surname, email: User.current!.email, city: request.city!, state: request.state!, country: request.country!, postCode: request.postalCode!, street: request.addressLine1!, completion: {(checkoutID) in
            DispatchQueue.main.async {
                
                guard let checkoutID = checkoutID else {
                    self.dismiss(animated: true, completion: nil)
                    self.showError(title: "generic.failure".localized, message: "generic.checkoutIDNotFound".localized, sender: self.view)
                    return
                }
                    
                    self.checkoutID = checkoutID
                    print(self.checkoutID)
                self.checkoutProvider = self.configureCheckoutProvider(checkoutID: self.checkoutID)
                    self.checkoutProvider?.delegate = self
                    self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                        DispatchQueue.main.async {
                            self.handleTransactionSubmission(transaction: transaction, error: error)
                        }
                    }, cancelHandler: nil) }
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
            let request = PaymentProfileWorker.Request(address: "\(request.addressLine1!)",
                state: "\(request.state!)",
                city: "\(request.city!)",
                postalCode: "\(request.postalCode!)",
                country: "\(request.country!)",
                language: "\(request.language ?? "English")")
            return (request)
        } else {
            return nil
        }
    }
    //Added by Hassan Bhatti - END

    
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

//Added By Hassan Bhatti
extension PaymentProfileViewController: OPPCheckoutProviderDelegate {
    
    
    func showError(title:String,message:String,sender:UIView) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "generic.ok".localized, style: .default, handler: nil)
        alertController.addAction(action)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - OPPCheckoutProviderDelegate methods
    
    // This method is called right before submitting a transaction to the Server.
    func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, continueSubmitting transaction: OPPTransaction, completion: @escaping (String?, Bool) -> Void) {
        // To continue submitting you should call completion block which expects 2 parameters:
        // checkoutID - you can create new checkoutID here or pass current one
        // abort - you can abort transaction here by passing 'true'
        completion(transaction.paymentParams.checkoutID, false)
    }
    
    // MARK: - Payment helpers
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus(sender: self.view)
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        } else {
            Utils.showResult(presenter: self, success: false, message: "generic.invalidTransaction".localized )
        }
    }
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        let provider = OPPPaymentProvider.init(mode: .live)
//        let provider = OPPPaymentProvider(mode: .live) //For Live Payments - Hassan Bhatti
        let checkoutSettings = Utils.configureCheckoutSettings()
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
    }
    
    func requestPaymentStatus(sender:UIView) {
        guard let resourcePath = self.transaction?.resourcePath else {
            Utils.showResult(presenter: self, success: false, message: "Resource path is invalid")
            return
        }
        
        self.transaction = nil
//         Request.requestPaymentStatus(resourcePath: resourcePath, vc:self) { (success,msg) in
        Request.newRequestPaymentStatus(checkoutID: self.checkoutID, vc:self) { (success,msg) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
//                Utils.showResult(presenter: self, success: true, message: msg)
//                let message = success ? "Your payment was successful" : "Your payment was not successful"
                
                //After Payment Success - Hassan Bhatti
                if success {
//                    Utils.showResult(presenter: self, success: success, message: message) //commented by Hassan Bhatti
                
                    let alertController = UIAlertController(title: "generic.success".localized, message: "generic.paymentSuccess".localized, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "generic.ok".localized, style: .default, handler: { (action) in
                        RappleActivityIndicatorView.startAnimating()
                        guard let request = self.validateFormWith(request: self.request) else {
                            return
                        }
                        
                        self.worker.sendPaymentProfileDetailsWith(request: request, completion: { [weak self] (response, error) in
                            guard let `self` = self else { return }
//                            if let error = error {
//                                self.presenter?.handleError(error)
//                                return
//                            }
                            
                            // commented by Najam
//                            if response != nil {
//                                self.dismiss(animated: true, completion: nil)
//                            }
                            
                            
                            // Added by Najam
                            RappleActivityIndicatorView.stopAnimation()
                            self.navigationController?.popViewController(animated: false)
                            self.delegate?.paymentSuccess()

                        })
                            
                    })
                    alertController.addAction(alertAction)
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = sender
                        popoverController.sourceRect = sender.bounds
                    }
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    Utils.showResult(presenter: self, success: success, message: "generic.paymentFailed".localized)
                }
            }
        }
    }
    
    // MARK: - Async payment callback
    
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        self.checkoutProvider?.dismissCheckout(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus(sender: self.view)
            }
        }
    }
    // MARK: Payment End
}

extension PaymentProfileViewController: CountryPickerDelegate {
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        countryView.textField.text = countryCode
        print("\(phoneCode)")
    }
}
