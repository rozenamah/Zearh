import UIKit

class CallDoctorRouter: Router {
    typealias RoutingViewController = CallDoctorViewController
    weak var viewController: CallDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showProfessionSelection() {
        
        let alert = UIAlertController(title: "Profession", message: "Please choose your profession", preferredStyle: .actionSheet)
        Profession.all.forEach { (profession) in
            alert.addAction(UIAlertAction(title: profession.title, style: .default, handler: { (action) in
                self.viewController?.professionSelected(profession)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func showSpecializationSelection() {
        
        let alert = UIAlertController(title: "Specialization", message: "Please choose your specialization", preferredStyle: .actionSheet)
        DoctorSpecialization.all.forEach { (specialization) in
            alert.addAction(UIAlertAction(title: specialization.title, style: .default, handler: { (action) in
                self.viewController?.specializationSelected(specialization)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    /// This view is in container, we animate it so it goes down
    func dismiss() {
        if let containerView = viewController?.view.superview {
            var animateFrame = containerView.frame
            animateFrame.origin.y = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.4, animations: {
                containerView.frame = animateFrame
            })
        }
    }

    // MARK: Passing data

}
