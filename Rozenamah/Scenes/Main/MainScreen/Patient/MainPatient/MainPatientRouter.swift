import UIKit

class MainPatientRouter: MainScreenRouter, Router {
    typealias RoutingViewController = MainPatientViewController
    weak var viewController: MainPatientViewController?
    
    override var baseViewController: MainScreenViewController? {
        return viewController
    }
    

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
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Navigation
    
    /// Adds call doctor form at app start
    func configureFirstScreen() {
        add(asChildViewController: callFormVC)
        viewController?.containerHeightConstraint.constant = 433
    }
    
    func openContainer(completion: (()->Void)? = nil) {
        animateOpenContainer(completion: completion)
    }
    
    func closeContainer() {
        animateCloseContainer {
            // Do nothing
        }
    }
    
    func navigateToDoctorOnTheWay() {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.doctorLocationVC)
            self.viewController?.containerHeightConstraint.constant = 307
            self.openContainer()
        }
    }
    
    func navigateToCallForm() {
        animateCloseContainer {[weak self] in
            guard let `self` = self else {
                return
            }
            
            self.add(asChildViewController: self.callFormVC)
            self.viewController?.containerHeightConstraint.constant = 433
            self.openContainer()
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

}
