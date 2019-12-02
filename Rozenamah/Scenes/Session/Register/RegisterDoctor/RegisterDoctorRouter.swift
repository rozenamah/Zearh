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
    
    func showDoctorCreatedAlert(withDismiss dismiss: Bool, sender:UIView) {
        let alert = UIAlertController(title: "session.doctor.accCreated".localized, message: "session.doctor.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { (_) in
            if dismiss {
                self.dismiss()
            } else {
                self.navigateToDefaultApp()
            }
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func showGenderSelection(sender:UIView) {
        let alert = UIAlertController(title: "session.doctor.genderInfo".localized, message: "session.doctor.gender".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "session.doctor.male".localized, style: .default, handler: { (action) in
            self.viewController?.genderSelected(.male)
        }))
        alert.addAction(UIAlertAction(title: "session.doctor.female".localized, style: .default, handler: { (action) in
            self.viewController?.genderSelected(.female)
        }))
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
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
        alertLoading = showLoadingAlert(sender: viewController!.view)
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
//        viewController?.dismiss(animated: true, completion: nil)
        
        if let fileData = try? Data(contentsOf: url) {
            viewController?.pdfFileSelected(inData: fileData)
        }
        
    }
}
