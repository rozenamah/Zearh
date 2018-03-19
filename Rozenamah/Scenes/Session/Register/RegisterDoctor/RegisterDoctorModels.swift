import UIKit

enum Gender {
    case male
    case female
}

final class RegisterDoctorForm: RegisterForm {
    var profession: String?
    var specialization: String?
    var price: Int?
    var gender: Gender?
    var pdf: Data?
    
    override var toParams: [String: Any] {
        var params = super.toParams
        return params
    }
    
}
