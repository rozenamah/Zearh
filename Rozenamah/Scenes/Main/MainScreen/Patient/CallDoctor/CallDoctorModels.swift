import UIKit

class CallDoctorForm {
    
    var classification: Classification?
    var specialization: DoctorSpecialization?
    var minPrice: Int?
    var maxPrice: Int?
    var gender: Gender?
    
    init() {
        // Do nothing, everything will be nil
    }
    
    /// Copying constructor, used when we edit filters without saving
    init(formToCopy: CallDoctorForm) {
        self.minPrice = formToCopy.minPrice
        self.maxPrice = formToCopy.maxPrice
        self.gender = formToCopy.gender
        self.classification = formToCopy.classification
        self.specialization = formToCopy.specialization
    }
    
}
