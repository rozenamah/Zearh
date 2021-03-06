import UIKit
import SwiftCake

class RegisterPatientRouter: NSObject, Router, AlertRouter, PhotoTakeRouter, AppStartRouter {
    typealias RoutingViewController = RegisterPatientViewController
    weak var viewController: RegisterPatientViewController?

    /// Alert view, displayed when registering user
    private var alertLoading: UIAlertController?
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "terms_segue":
            let navVC = segue.destination as? UINavigationController
            let termsVC = navVC?.visibleViewController as? TermsViewController
            termsVC?.source = .terms
        case "doctor_step_segue":
            let registerStep2 = segue.destination as? RegisterDoctorViewController
            let doctorForm = viewController?.registerForm as? RegisterDoctorForm
            
            // Reset doctor form if we for example, returned and access next step again
            doctorForm?.price = nil
            doctorForm?.classification = nil
            doctorForm?.specialization = nil
            doctorForm?.pdf = nil
            doctorForm?.gender = nil
            
            registerStep2?.registerForm = doctorForm
        default:
            break
        }
    }

    // MARK: Navigation
    
    func navigateToDoctorStep2() {
        viewController?.performSegue(withIdentifier: "doctor_step_segue", sender: nil)
    }
    
    func showWaitAlert(sender:UIView) {
        alertLoading = showLoadingAlert(sender: sender)
    }
    
    func hideWaitAlert(completion: (() -> Void)? = nil) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }

    // MARK: Passing data

}


extension RegisterPatientRouter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage,
            let resizedImage = image.resizeImage(toMaxDimension: 300) else {
            return
        }
        
        picker.dismiss(animated: false) {
            self.viewController?.displaySelectedAvatar(image: resizedImage)
        }
    }
}
