import UIKit
import GoogleMaps

class MainDoctorRouter: MainScreenRouter, Router, AlertRouter {
    typealias RoutingViewController = MainDoctorViewController
    weak var viewController: MainDoctorViewController?

    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    
    private static let kVisitRequestNotification = Notification.Name("kVisitRequestNotification")
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainDoctorRouter.kVisitRequestNotification, object: nil)
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
        NotificationCenter.default.post(name: MainDoctorRouter.kVisitRequestNotification, object: nil, userInfo: ["visit" : booking])
    }

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "end_visit_segue" {
            
        }
    }

    // MARK: Navigation
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["visit"] as? Booking {
            patientFormVC.booking = booking
            viewController?.presentUser(in: CLLocation(latitude: booking.latitude, longitude: booking.longitude))
            viewController?.animateToPosition(GMSCameraPosition(target: booking.patientLocation.coordinate, zoom: 15.0, bearing: 0.0, viewingAngle: 0.0))
            openContainer()
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
        }
        
        self.add(asChildViewController: self.waitVC)
        self.viewController?.containerHeightConstraint.constant = 202
        self.waitVC.state = .waitForPayDoctor
        
        self.openContainer()
    }
    
    func navigateToEndVisit() {
        viewController?.performSegue(withIdentifier: "end_visit_segue", sender: nil)
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
