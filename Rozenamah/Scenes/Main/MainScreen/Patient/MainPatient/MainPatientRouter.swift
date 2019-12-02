import UIKit

class MainPatientRouter: MainScreenRouter, Router, AppStartRouter, AlertRouter {
    typealias RoutingViewController = MainPatientViewController
    weak var viewController: MainPatientViewController?
    
    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    
    static let kVisitRequestNotification = Notification.Name("kPatientVisitRequestNotification")
    static let kNoVisitRequestNotification = Notification.Name("kPatientNoVisitRequestNotification")

    lazy var waitVC: WaitViewController = {
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wait_vc") as! WaitViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var callFormVC: CallDoctorViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "call_vc") as! CallDoctorViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var acceptDoctorVC: AcceptDoctorViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accept_vc") as! AcceptDoctorViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var doctorLocationVC: DoctorLocationViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "doctor_location_vc") as! DoctorLocationViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainPatientRouter.kVisitRequestNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoBooking), name: MainPatientRouter.kNoVisitRequestNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Routing
    
    static func resolve(booking: Booking) {
        NotificationCenter.default.post(name: MainPatientRouter.kVisitRequestNotification, object: nil, userInfo: ["booking" : booking])
    }
    
    static func stopAllBookings() {
        NotificationCenter.default.post(name: MainPatientRouter.kNoVisitRequestNotification, object: nil, userInfo: nil )
    }

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation
    
    
    @objc func handleNoBooking() {
        // Called when system is notified there is no more booking to display, hide current view
        LoginUserManager.sharedInstance.bookingStatus = nil
        LoginUserManager.sharedInstance.visitFound = false
        navigateToCallForm()
        // There might be modal screen - hide it
        viewController?.dismiss(animated: true, completion: nil)
        
        if let booking = LoginUserManager.sharedInstance.lastBooking {
            booking.status = BookingStatus.ended
            LoginUserManager.sharedInstance.lastBooking = nil
            
            //added by Najam
            //goto visit end popUp for showing details
//            navigateToEndVisitPopUp(withBooking: booking)
        }
    }
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.patient == User.current {
            print(booking.status)
            
            if booking.status == .ended || booking.status == .canceled || booking.status == .rejected {
                viewController?.lblAddress.isHidden = false
                viewController?.pinImage.isHidden = false
            } else {
                viewController?.lblAddress.isHidden = true
                viewController?.pinImage.isHidden = true
            }
            if booking.status == .new {
                navigateToWaitForAccept(withBooking: booking)
                
                // Save booking
                viewController?.currentBooking = booking
            } else if booking.status == .canceled {
                navigateToCallForm()
                
                // Move camera back to center and remove current booking
                viewController?.removeCurrentDoctorLocation()
                viewController?.currentBooking = nil
                
                showAlert(message: "alerts.visitCanceled".localized, sender: viewController!.view)
            } else if booking.status == .accepted {
                navigateToDoctorOnTheWay(for: booking)
                
                // Move camera to doctor location
                viewController?.currentBooking = booking
                viewController?.moveToDoctorLocation(inBooking: booking)
            } else if booking.status == .rejected {
                navigateToCallForm()
                
                // Remove current booking
                viewController?.currentBooking = nil
                
                showAlert(message: "alerts.doctorRejected".localized, sender: viewController!.view)
            } else if booking.status == .timeout {
                navigateToCallForm()
                
                // Move camera back to center and remove current booking
                viewController?.removeCurrentDoctorLocation()
                viewController?.currentBooking = nil
                
                showAlert(message: "alerts.doctorDidntAccepted".localized, sender: viewController!.view)
            } else if booking.status == .arrived {
                navigateToWaitForVisitEnd(withBooking: booking)
                
                // Save booking
                viewController?.currentBooking = booking
            } else if booking.status == .ended {
                // TODO: Navigate to transactions?
                navigateToCallForm()
                
                // Move camera back to center and remove current booking
                viewController?.removeCurrentDoctorLocation()
                viewController?.currentBooking = nil
                
            } else if booking.status == .waitingForPayment {
                showPayByCardScreenWith(booking: booking)
                //TODO waiting for payment navigation
            }
            
        }
    }
    
    func navigateToAppAfterAccountVerified() {
        self.navigateToDefaultApp()
    }
    
    func closeContainer() {
        animateCloseContainer {
            // Do nothing
        }
    }
    
    func navigateToDoctorOnTheWay(for booking: Booking) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.doctorLocationVC)
            self.viewController?.containerHeightConstraint.constant = 251
            self.doctorLocationVC.booking = booking
            self.openContainer()
        }
    }
    
    func navigateToCallForm(
        withClosePrevious previous: Bool = true, completion: (()->())? = nil) {
      
      // KAMIL - I'm not sure what this line actually doing
//        if currentViewController is CallDoctorViewController {
//            return
//        }
      
        let openCallDoctor = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.callFormVC)
            self.viewController?.containerHeightConstraint.constant = 455
            self.openContainer(completion: completion)
        }
        
        if previous {
            animateCloseContainer {
                openCallDoctor()
            }
        } else {
            openCallDoctor()
        }
    }
    
    func navigateToAcceptDoctor(withDoctor doctor: VisitDetails, byFilters filters: CallDoctorForm) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.acceptDoctorVC)
            self.viewController?.containerHeightConstraint.constant = 320
            self.acceptDoctorVC.visitInfo = doctor // Pass found doctor
            self.acceptDoctorVC.filters = filters
            
            self.openContainer()
        }
    }
    
    func navigateToSearchScreen(withFilters form: CallDoctorForm) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.waitVC)
            self.viewController?.containerHeightConstraint.constant = 202
            self.waitVC.state = .waitSearch(filters: form) // Pass current filters
            
            self.openContainer()
        }
    }
    
    func navigateToWaitForAccept(withBooking booking: Booking) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.waitVC)
            self.viewController?.containerHeightConstraint.constant = 202
            self.waitVC.state = .waitAccept(booking: booking) // Pass current booking
            
            self.openContainer()
        }
    }

    func navigateToWaitForVisitEnd(withBooking booking: Booking) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.waitVC)
            self.viewController?.containerHeightConstraint.constant = 162
            self.waitVC.state = .waitForVisitEnd(booking: booking) // Pass current booking
            
            self.openContainer()
        }
    }
    
    
    func navigateToEndVisitPopUp(withBooking booking: Booking) {
       let vc = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "EndVisitPopUpViewController") as! EndVisitPopUpViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.booking = booking
        vc.currentMode = .patient
        self.viewController?.present(vc, animated: true, completion: nil)
    }
    
    func showPayByCardScreenWith(booking: Booking) {
        guard let navigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "payment_vc") as? UINavigationController, let destinationVC = navigationVC.viewControllers.first as? PaymentViewController else {
            print("Cannot initalize payment view controller")
            return
        }
        destinationVC.booking = booking
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.delegate = self
        viewController?.present(navigationVC, animated: true, completion: nil)
    }
    
}

extension MainPatientRouter: PaymentViewDelegate {
    func onPaymentDone() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
