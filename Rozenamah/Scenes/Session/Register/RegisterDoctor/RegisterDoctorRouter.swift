import UIKit
import MobileCoreServices

class RegisterDoctorRouter: NSObject, Router, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    typealias RoutingViewController = RegisterDoctorViewController
    weak var viewController: RegisterDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    func navigateToImportFile() {
    
        var types: [String] = [String]()
        types.append(contentsOf: [String(kUTTypePDF)])
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPickerController.delegate = self
        viewController?.present(documentPickerController, animated: true, completion: nil)
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
