import UIKit
import GoogleMaps

class MainDoctorRouter: MainScreenRouter, Router, AlertRouter {
    typealias RoutingViewController = MainDoctorViewController
    weak var viewController: MainDoctorViewController?

    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    
    static let kVisitRequestNotification = Notification.Name("kDoctorVisitRequestNotification")
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainDoctorRouter.kVisitRequestNotification, object: nil)
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

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "end_visit_segue":
            let navVC = segue.destination as? UINavigationController
            let endVisit = navVC?.visibleViewController as? EndVisitViewController
            endVisit?.booking = sender as? Booking
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
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking {
            
            if booking.status == .new {
                viewController?.moveToPatientLocation(inBooking: booking)
                navigateToPatientToAccept(inBooking: booking)
            } else if booking.status == .canceled {
                navigateToCancel()
            } else if booking.status == .accepted {
                navigateToDoctorOnTheWay(onBooking: booking)
            } else if booking.status == .arrived {
                navigateToEndVisit(withBooking: booking)
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
            self.viewController?.containerHeightConstraint.constant = 202
            self.waitVC.state = .waitForPayDoctor
            
            self.openContainer()
        }
        
    }
    
    /// Adds patient form at app start
    func configureFirstScreen() {
        add(asChildViewController: patientFormVC )
        viewController?.containerHeightConstraint.constant = 370
    }
    
    func openContainer(completion: (() -> Void)? = nil) {
        animateOpenContainer(completion: completion)
    }

    func navigateToCancel() {
        animateCloseContainer {
            // Do nothing
        }
    }

    // MARK: Passing data
}
