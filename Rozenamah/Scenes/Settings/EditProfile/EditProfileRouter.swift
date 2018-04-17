import UIKit

class EditProfileRouter: NSObject, Router, PhotoTakeRouter, ClassificationRouter, AlertRouter {
    typealias RoutingViewController = EditProfileViewController
    weak var viewController: EditProfileViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showSuccessChangeAlert() {
        let alert = UIAlertController(title: "Success", message: "Your profile has been updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Ups, something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "Delete account", message: "Are you sure you want to remove user's account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.viewController?.deleteConfirm()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
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
