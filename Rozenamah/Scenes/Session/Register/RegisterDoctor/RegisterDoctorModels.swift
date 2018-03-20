import UIKit

enum Profession: String {
    case doctor = "Doctor"
    case nurse = "Nurse"
    
    static var all: [Profession] {
        return [.doctor, .nurse, ]
    }
}

enum Gender: String {
    case male = "male"
    case female = "female"
}

final class RegisterDoctorForm: RegisterForm {
    var profession: Profession?
    var specialization: String?
    var price: Int?
    var gender: Gender?
    var pdf: Data?
    
    override var toParams: [String: Any] {
        var params = super.toParams
        return params
    }
    
}
