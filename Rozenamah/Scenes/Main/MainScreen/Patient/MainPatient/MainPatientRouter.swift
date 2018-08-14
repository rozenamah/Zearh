import UIKit

class MainPatientRouter: MainScreenRouter, Router, AlertRouter {
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
        navigateToCallForm()
        // There might be modal screen - hide it
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.patient == User.current {
            
            if booking.status == .new {
                navigateToWaitForAccept(withBooking: booking)
                
                // Save booking
                viewController?.currentBooking = booking
            } else if booking.status == .canceled {
                navigateToCallForm()
                
                // Move camera back to center and remove current booking
                viewController?.removeCurrentDoctorLocation()
                viewController?.currentBooking = nil
                
                showAlert(message: "Visit canceled, please try another one.")
            } else if booking.status == .accepted {
                navigateToDoctorOnTheWay(for: booking)
                
                // Move camera to doctor location
                viewController?.currentBooking = booking
                viewController?.moveToDoctorLocation(inBooking: booking)
            } else if booking.status == .rejected {
                navigateToCallForm()
                
                // Remove current booking
                viewController?.currentBooking = nil
                
                showAlert(message: "Doctor rejected your visit request.")
            } else if booking.status == .timeout {
                navigateToCallForm()
                
                // Move camera back to center and remove current booking
                viewController?.removeCurrentDoctorLocation()
                viewController?.currentBooking = nil
                
                showAlert(message: "Doctor didn't accept visit within 15 minutes.")
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
                showPayByCardScreen()
                //TODO waiting for payment navigation
            }
            
        }
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
            self.viewController?.containerHeightConstraint.constant = 433
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
            self.viewController?.containerHeightConstraint.constant = 286
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
    
    func showPayByCardScreen() {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "payment_vc")
        destinationVC.modalPresentationStyle = .overCurrentContext
        viewController?.present(destinationVC, animated: true, completion: nil)
    }
    
}
