import UIKit

class EditProfileRouter: NSObject, Router, PhotoTakeRouter, ClassificationRouter, AlertRouter, AppStartRouter {
    typealias RoutingViewController = EditProfileViewController
    weak var viewController: EditProfileViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func navigateToWelcomeScreen() {
        viewController?.dismiss(animated: true, completion: {
            self.navigateToSignUp()
        })
    }
    
    func showSuccessChangeAlert(sender:UIView) {
        let alert = UIAlertController(title: "generic.success".localized,
                                      message: "alerts.profileUpadted.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(sender:UIView) {
        let alert = UIAlertController(title: "generic.error.error".localized,
                                      message: "errors.somethingWentWrong".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func showDeleteAlert(sender:UIView) {
        let alert = UIAlertController(title: "settings.editProfile.deleteAccount".localized,
                                      message: "alerts.deleteAccount.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.yes".localized, style: .default, handler: { (action) in
            self.viewController?.deleteConfirm()
        }))
        alert.addAction(UIAlertAction(title: "generic.no".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Passing data

}

extension EditProfileRouter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
