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
    
    func navigateToAcceptDoctor(withDoctor doctor: DoctorResult, byFilters filters: CallDoctorForm) {
        animateCloseContainer { [weak self] in
            guard let `self` = self else {
                return
            }
            self.add(asChildViewController: self.acceptDoctorVC)
            self.viewController?.containerHeightConstraint.constant = 286
            self.acceptDoctorVC.doctor = doctor // Pass found doctor
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
            self.waitVC.filters = form // Pass current filters
            
            self.openContainer()
        }
    }
    

}
