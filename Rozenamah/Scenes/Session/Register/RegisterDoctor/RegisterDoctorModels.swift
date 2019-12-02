import UIKit

protocol ParamForm {
    var toParams: [String: Any] { get }
}

protocol CreateDoctorForm: ParamForm {
    var classification: Classification? { get set }
    var specialization: DoctorSpecialization? { get set }
    var price: Int? { get set }
    var gender: Gender? { get set }
    var pdf: Data? { get set }
    var language: String? { get set }
}

final class UpdateDoctorForm: CreateDoctorForm {
    var language: String?
    var classification: Classification?
    var specialization: DoctorSpecialization?
    var price: Int?
    var gender: Gender?
    var pdf: Data?
    
    var toParams: [String: Any] {
        var params = [String: Any]()
        
        params["classification"] = classification!.rawValue
        if let specialization = specialization?.rawValue {
            params["specialization"] = specialization
        }
        params["gender"] = gender!.rawValue
        params["price"] = price!
        params["type"] = "doctor"
        params["pdf"] = "data:application/pdf;base64,\(pdf!.base64EncodedString())"
        params["lang"] = language ?? "en"
        return params
    }
}

final class RegisterDoctorForm: RegisterForm, CreateDoctorForm {
    var classification: Classification?
    var specialization: DoctorSpecialization?
    var price: Int?
    var gender: Gender?
    var pdf: Data?
    
    override var toParams: [String: Any] {
        var params = super.toParams
        
        params["classification"] = classification!.rawValue
        if let specialization = specialization?.rawValue {
            params["specialization"] = specialization
        }
        params["gender"] = gender!.rawValue
        params["price"] = price!
        params["type"] = "doctor"
        params["pdf"] = "data:application/pdf;base64,\(pdf!.base64EncodedString())"
        params["lang"] = language ?? "en"
        return params
    }
}
