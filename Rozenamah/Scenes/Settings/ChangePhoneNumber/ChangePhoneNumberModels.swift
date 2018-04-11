import UIKit

class PhoneNumberForm: ParamForm {
    var phoneNumber: String?
    
    var toParams: [String : Any] {
        let params = [
            "email": phoneNumber!
        ]
        return params
    }
}
