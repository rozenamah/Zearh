import UIKit
import MobileCoreServices

class RegisterDoctorRouter: NSObject, Router, AppStartRouter, UINavigationControllerDelegate, UIDocumentPickerDelegate, AlertRouter, ClassificationRouter {
    
    typealias RoutingViewController = RegisterDoctorViewController
    weak var viewController: RegisterDoctorViewController?

    /// Alert view, displayed when registering doctor
    private var alertLoading: UIAlertController?
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    /// Called when this view is presented in modal, during updating account
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showDoctorCreatedAlert() {
        let alert = UIAlertController(title: "Account created", message: "Please, wait until you account will be verified. It shouldn't take more than 24 hours. Until then, you can user application as patient.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.navigateToApp(inModule: .patient)
        }))
    }
    
    func showGenderSelection() {
        let alert = UIAlertController(title: "Gender", message: "Please choose your gender", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { (action) in
            self.viewController?.genderSelected(.male)
        }))
        alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { (action) in
            self.viewController?.genderSelected(.female)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func navigateToImportFile() {
    
        var types: [String] = [String]()
        types.append(String(kUTTypePDF))
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPickerController.delegate = self
        viewController?.present(documentPickerController, animated: true, completion: nil)
    }
    
    func showWaitAlert() {
        alertLoading = showLoadingAlert()
    }
    
    func hideWaitAlert(completion: (() -> Void)? = nil) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
    
    // MARK: Passing data

    /// Called when pdf to import is selected
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentAt url: URL) {
        
        print("Selected URL: \(url)")
        
        // Dismiss this view
        viewController?.dismiss(animated: true, completion: nil)
        
        if let fileData = try? Data(contentsOf: url) {
            viewController?.pdfFileSelected(inData: fileData)
        }
        
    }
}
