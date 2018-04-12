import UIKit

let kMaxPriceToFilter = 501

class CallDoctorForm {
    
    var classification: Classification? {
        didSet {
            // Reset specialization and price
            if classification == .nurse || classification == .doctor {
                specialization = nil
                minPrice = nil
                maxPrice = nil
            }
        }
    }
    var specialization: DoctorSpecialization?
    var minPrice: Int? {
        didSet {
            if minPrice == 0 {
                minPrice = nil
            }
        }
    }
    var maxPrice: Int? {
        didSet {
            if maxPrice == kMaxPriceToFilter {
                maxPrice = nil
            }
        }
    }
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
