import UIKit
import CoreLocation

protocol CallDoctorBusinessLogic {
    func validate(form: CallDoctorForm) -> Bool
}

class CallDoctorInteractor: CallDoctorBusinessLogic {
	var presenter: CallDoctorPresentationLogic?
	var worker = CallDoctorWorker()

	// MARK: Business logic
    
    func validate(form: CallDoctorForm) -> Bool {
        var allFieldsValid = true
        
        // Profession verification
        if form.classification == nil {
            allFieldsValid = false
            presenter?.presentError(.professionMissing)
        }
        
        // Specialization verification
        if (form.classification == .consultants ||
            form.classification == .specialist),
            form.specialization == nil  {
            
            allFieldsValid = false
            presenter?.presentError(.specializationMissing)
        }
        
        // Verify if there is any user location
        let locationManager = CLLocationManager()
        if locationManager.location == nil {
            allFieldsValid = false
            presenter?.presentError(.noLocation)
        }
        
        return allFieldsValid
    }
    
	
}
