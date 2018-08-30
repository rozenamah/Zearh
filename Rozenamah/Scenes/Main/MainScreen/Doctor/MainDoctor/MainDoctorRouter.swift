import UIKit
import GoogleMaps

class MainDoctorRouter: MainScreenRouter, Router, AlertRouter {
    typealias RoutingViewController = MainDoctorViewController
    weak var viewController: MainDoctorViewController?

    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    
    static let kVisitRequestNotification = Notification.Name("kDoctorVisitRequestNotification")
    static let kNoVisitRequestNotification = Notification.Name("kDoctorNoVisitRequestNotification")
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainDoctorRouter.kVisitRequestNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoBooking), name: MainDoctorRouter.kNoVisitRequestNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var patientFormVC: AcceptPatientViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accept_patient_vc") as! AcceptPatientViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var doctorBusyVC: DoctorOnTheWayViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "busy_doctor_vc") as! DoctorOnTheWayViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    lazy var waitVC: WaitViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wait_vc") as! WaitViewController
        vc.doctorFlowDelegate = viewController
        return vc
    }()
    
    
    // MARK: Routing
    
    static func resolve(booking: Booking) {
        NotificationCenter.default.post(name: MainDoctorRouter.kVisitRequestNotification, object: nil, userInfo: ["booking" : booking])
    }
    
    static func stopAllBookings() {
        NotificationCenter.default.post(name: MainDoctorRouter.kNoVisitRequestNotification, object: nil, userInfo: nil )
    }

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "end_visit_segue":
            let navVC = segue.destination as? UINavigationController
            let endVisit = navVC?.visibleViewController as? EndVisitViewController
            endVisit?.booking = sender as? Booking
            endVisit?.flowDelegate = viewController
        default:
            break
        }
    }

    // MARK: Navigation
    
    func navigateToEndVisit(withBooking booking:Booking) {
        // Close current view
        animateCloseContainer {
            self.viewController?.performSegue(withIdentifier: "end_visit_segue", sender: booking)
        }
    }
    
    @objc func handleNoBooking() {
        // Called when system is notified there is no more booking to display, hide current view
        navigateToCancel()
        // There might be modal screen - hide it
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.visit.user == User.current {
            
            if booking.status == .new {
                navigateToPatientToAccept(inBooking: booking)
                
                // Save booking and move camera to patient location
                viewController?.currentBooking = booking
                viewController?.moveToPatientLocation(inBooking: booking)
            } else if booking.status == .canceled {
                navigateToCancel()
                
                // Remove booking and move camera to doctor (my) location
                viewController?.currentBooking = nil
                viewController?.removeCurrentPatientLocation()
                
                showAlert(message: "alerts.visitCanceled2".localized)
            } else if booking.status == .timeout {
                navigateToCancel()
                
                // Remove booking and move camera to doctor (my) location
                viewController?.currentBooking = nil
                viewController?.removeCurrentPatientLocation()
                
                showAlert(message: "alerts.youDidntAccepted".localized)
            } else if booking.status == .accepted {
                navigateToDoctorOnTheWay(onBooking: booking)
                
                // Save booking and move camera to patient location
                viewController?.currentBooking = booking
                viewController?.moveToPatientLocation(inBooking: booking)
            } else if booking.status == .arrived {
                navigateToEndVisit(withBooking: booking)
                
                // Remove booking
                viewController?.currentBooking = nil
            } else if booking.status == .waitingForPayment {
                navigateToCancel()
                navigateToWaitForPayment()
                
                viewController?.currentBooking = nil
            }
            
        }
    }
    
    func navigateToPatientToAccept(inBooking booking: Booking) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.patientFormVC)
            self.patientFormVC.booking = booking
            self.viewController?.containerHeightConstraint.constant = 370
            self.openContainer()
        }
    }
    
    
    func navigateToDoctorOnTheWay(onBooking booking: Booking) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.doctorBusyVC)
            self.viewController?.containerHeightConstraint.constant = 309
            self.doctorBusyVC.booking = booking
            self.openContainer()
        }
    }
    
    func navigateToWaitForPayment() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.waitVC)
            self.viewController?.containerHeightConstraint.constant = 162
            self.waitVC.state = .waitForPayDoctor
            
            self.openContainer()
        }
        
    }
    
    
    /// Adds patient form at app start
    func configureFirstScreen() {
        add(asChildViewController: patientFormVC )
        viewController?.containerHeightConstraint.constant = 370
    }

    func navigateToCancel() {
        animateCloseContainer {
            // Do nothing
        }
    }

    // MARK: Passing data
}
