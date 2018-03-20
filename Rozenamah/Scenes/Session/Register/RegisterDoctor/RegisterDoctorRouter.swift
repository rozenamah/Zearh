import UIKit
import MobileCoreServices

class RegisterDoctorRouter: NSObject, Router, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    typealias RoutingViewController = RegisterDoctorViewController
    weak var viewController: RegisterDoctorViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showProfessionSelection() {
        
        let alert = UIAlertController(title: "Profession", message: "Please choose your profession", preferredStyle: .actionSheet)
        Profession.all.forEach { (profession) in
            alert.addAction(UIAlertAction(title: profession.rawValue, style: .default, handler: { (action) in
                self.viewController?.professionSelected(profession)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }

    func showSpecializationSelection() {
        let specializations = [
            "Cardiology",
            "Geriatrics",
            "Infectious Diseases",
            "Neonatology",
            "Onclogy",
            "Opthalmology",
            "Orthopedics",
            "Respiratory",
            "Urology",
        ]
        
        let alert = UIAlertController(title: "Specialization", message: "Please choose your specialization", preferredStyle: .actionSheet)
        specializations.forEach { (specialization) in
            alert.addAction(UIAlertAction(title: specialization, style: .default, handler: { (action) in
                self.viewController?.specializationSelected(specialization)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
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
