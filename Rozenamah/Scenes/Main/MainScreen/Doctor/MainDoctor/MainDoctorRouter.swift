import UIKit

class MainDoctorRouter: MainScreenRouter, Router, AlertRouter {
    typealias RoutingViewController = MainDoctorViewController
    weak var viewController: MainDoctorViewController?

    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    // Variable for passing data to doctorBusyVC
    private var visitDetails: VisitDetails?
    
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
    
    lazy var doctorBusyVC: BusyDoctorViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "busy_doctor_vc") as! BusyDoctorViewController
        vc.flowDelegate = viewController
        return vc
    }()
    
    
    // MARK: Routing
    
    static func resolve(visit: VisitDetails) {
        NotificationCenter.default.post(name: MainDoctorRouter.kVisitRequestNotification, object: nil, userInfo: ["visit" : visit])
    }

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation
    
    @objc func handleNotification(for notification: NSNotification) {
        if let visit = notification.userInfo?["visit"] as? VisitDetails {
            patientFormVC.visitInfo = visit
            visitDetails = visit
            openContainer()
        }
    }
    
    func navigateToDoctorBusy() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.doctorBusyVC)
            self.viewController?.containerHeightConstraint.constant = 309
            self.doctorBusyVC.visitInfo = self.visitDetails
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
