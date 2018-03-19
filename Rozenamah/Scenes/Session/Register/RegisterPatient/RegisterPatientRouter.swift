import UIKit
import SwiftCake

class RegisterPatientRouter: NSObject, Router, AlertRouter, PhotoTakeRouter, AppStartRouter {
    typealias RoutingViewController = RegisterPatientViewController
    weak var viewController: RegisterPatientViewController?

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
            registerStep2?.registerForm = viewController?.registerForm as? RegisterDoctorForm
        default:
            break
        }
    }

    // MARK: Navigation
    
    func navigateToDoctorStep2() {
        viewController?.performSegue(withIdentifier: "doctor_step_segue", sender: nil)
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
