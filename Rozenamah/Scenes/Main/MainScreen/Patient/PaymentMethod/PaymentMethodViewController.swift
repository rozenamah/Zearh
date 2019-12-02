import UIKit

protocol PaymentMethodDisplayLogic: class {
    func handle(error: Error)
    func bookingCreated(_ booking: Booking)
}

protocol PaymentMethodDelegate: class {
    func new(booking: Booking)
}

class PaymentMethodViewController: UIViewController, PaymentMethodDisplayLogic, OPPCheckoutProviderDelegate {

    // MARK: Outlets
    @IBOutlet weak var visitPriceLabel: UILabel!
    @IBOutlet weak var feePriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet var paymentMethodsButtons: [UIButton]!
    @IBOutlet weak var byCardButton: UIButton!
    @IBOutlet weak var byCashButton: UIButton!

    // MARK: For Payments
    //Added By Hassan Bhatti
    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    //END
    
    // MARK: Properties
    var interactor: PaymentMethodBusinessLogic?
    var router: PaymentMethodRouter?

    weak var delegate: PaymentMethodDelegate?
    
    /// Contains info about visit which user will take part if accept
    var doctor: VisitDetails!
    
    /// Selected payment method, passed to API when we select
    private var paymentMethod: PaymentMethod?
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: View customization

    fileprivate func setupView() {
        paymentMethodsButtons.forEach({ $0.isSelected = false })
        
        let cost = doctor.cost
        
        visitPriceLabel.text = "\(cost.price) SAR"
        totalPriceLabel.text = "\(cost.total) SAR"
        feePriceLabel.text = "\(cost.fee) SAR"
        
        if view.isRTL() {
            byCardButton.contentHorizontalAlignment = .right
            byCardButton.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 16)
            byCardButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16)
            byCashButton.contentHorizontalAlignment = .right
            byCashButton.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 16)
            byCashButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16)
        }
    }

    // MARK: Event handling
    @IBAction func paymentMethodAction(_ sender: UIButton) {
        paymentMethodsButtons.forEach({ $0.isSelected = false })
        if sender == byCardButton {
            byCardButton.isSelected = true
            paymentMethod = .card
        } else {
            byCashButton.isSelected = true
            paymentMethod = .cash
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if let paymentMethod = paymentMethod {
            router?.showWaitAlert(sender: sender as! UIView)
            interactor?.accept(doctor: doctor.user, withPaymentMethod: paymentMethod)
//            if paymentMethod == .cash {
                LoginUserManager.sharedInstance.visitFound = true
//            }
        }
        
//        Request.requestCheckoutID(amount: Double(doctor.cost.total), currency: Config.currency, completion: {(checkoutID) in
//            DispatchQueue.main.async {
////                self.processingView.stopAnimating()
////                sender.isEnabled = true
//
//                guard let checkoutID = checkoutID else {
//                    Utils.showResult(presenter: self, success: false, message: "Checkout ID is empty")
//                    return
//                }
//
//                self.checkoutProvider = self.configureCheckoutProvider(checkoutID: checkoutID)
//                self.checkoutProvider?.delegate = self
//                self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
//                    DispatchQueue.main.async {
//                        self.handleTransactionSubmission(transaction: transaction, error: error)
//                    }
//                }, cancelHandler: nil)
//            }
//        })
    }
//
//    // MARK: - OPPCheckoutProviderDelegate methods
//
//    // This method is called right before submitting a transaction to the Server.
//    func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, continueSubmitting transaction: OPPTransaction, completion: @escaping (String?, Bool) -> Void) {
//        // To continue submitting you should call completion block which expects 2 parameters:
//        // checkoutID - you can create new checkoutID here or pass current one
//        // abort - you can abort transaction here by passing 'true'
//        completion(transaction.paymentParams.checkoutID, false)
//    }
//
//    // MARK: - Payment helpers
//
//    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
//        guard let transaction = transaction else {
//            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
//            return
//        }
//
//        self.transaction = transaction
//        if transaction.type == .synchronous {
//            // If a transaction is synchronous, just request the payment status
//            self.requestPaymentStatus()
//        } else if transaction.type == .asynchronous {
//            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
//            // Subscribe to notifications to request the payment status when a shopper comes back to the app
//            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
//        } else {
//            Utils.showResult(presenter: self, success: false, message: "Invalid transaction")
//        }
//    }
//
//    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
//        let provider = OPPPaymentProvider.init(mode: .test)
////        let provider = OPPPaymentProvider(mode: .live) //For Live Payments - Hassan Bhatti
//        let checkoutSettings = Utils.configureCheckoutSettings()
//        checkoutSettings.storePaymentDetails = .prompt
//        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
//    }
//
//    func requestPaymentStatus() {
//        guard let resourcePath = self.transaction?.resourcePath else {
//            Utils.showResult(presenter: self, success: false, message: "Resource path is invalid")
//            return
//        }
//
//        self.transaction = nil
////        self.processingView.startAnimating()
//        Request.requestPaymentStatus(resourcePath: resourcePath) { (success) in
//            DispatchQueue.main.async {
////                self.processingView.stopAnimating()
//                let message = success ? "Your payment was successful" : "Your payment was not successful"
//
//                //After Payment Success - Hassan Bhatti
//                if success {
////                    Utils.showResult(presenter: self, success: success, message: message) //commented by Hassan Bhatti
//                    Utils.showResultWithHandler(presenter: self, success: success, message: message, handler: { (action) in
//                        if let paymentMethod = self.paymentMethod {
//                            self.router?.showWaitAlert()
//                            self.interactor?.accept(doctor: self.doctor.user, withPaymentMethod: paymentMethod)
//                        }
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                }
//                else {
////                    Utils.showResult(presenter: self, success: success, message: message) //commented by Hassan Bhatti
//                    Utils.showResultWithHandler(presenter: self, success: success, message: message, handler: { (action) in
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                }
//            }
//        }
//    }
//
//    // MARK: - Async payment callback
//
//    @objc func didReceiveAsynchronousPaymentCallback() {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
//        self.checkoutProvider?.dismissCheckout(animated: true) {
//            DispatchQueue.main.async {
//                self.requestPaymentStatus()
//            }
//        }
//    }
//    // MARK: Payment End
    
    @IBAction func closeAction(_ sender: Any) {
        router?.dismiss()
        LoginUserManager.sharedInstance.visitFound = false
    }
    
    // MARK: Presenter methods
    
    func handle(error: Error) {
        router?.hideWaitAlert(completion: {
            self.router?.showError(error, sender: self.view)
        })
    }
    
    func bookingCreated(_ booking: Booking) {
        router?.hideWaitAlert(completion: {
            self.delegate?.new(booking: booking)
            self.router?.dismiss()
        })
    }
}
