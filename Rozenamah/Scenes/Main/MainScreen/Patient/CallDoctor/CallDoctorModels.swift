import UIKit
import CoreLocation

let kMaxPriceToFilter: CGFloat = 5001

class CallDoctorForm: ParamForm {
    
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
            if maxPrice == Int(kMaxPriceToFilter) {
                maxPrice = nil
            }
        }
    }
    var gender: Gender?
    
    /// Location will be attached on patient main module, when passing between screens
    var location: CLLocation?
    var disabledDoctors = [User]()
    
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
    
    var toParams: [String : Any] {
        guard let location = location else {
            return [:]
        }
        
        var params: [String: Any] = [
            "classification": classification!.rawValue,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        if let specialization = specialization {
            params["specialization"] = specialization.rawValue
        }
        if let minPrice = minPrice {
            params["min_price"] = minPrice
        }
        if let maxPrice = maxPrice {
            params["max_price"] = maxPrice
        }
        if let gender = gender {
            params["gender"] = gender.rawValue
        }
        let disabledDoctorsId = disabledDoctors.map { $0.id }
        print(disabledDoctorsId)
        if !disabledDoctorsId.isEmpty {
            params["disabled_doctors"] = disabledDoctorsId
        }
        return params
    }
    
}
