import UIKit

class ResetPasswordForm {
    var email: String?
}

class ErrorResponse: Decodable {
    let code: Int
    let message: String
    let cause: String?
}
