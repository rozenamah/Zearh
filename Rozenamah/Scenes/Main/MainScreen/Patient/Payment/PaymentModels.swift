import UIKit

enum Payment {
    class Details: Decodable {
        private enum CodingKeys : String, CodingKey {
            case addressLine1 = "address_line_1"
            case addressLine2 = "address_line_2"
            case state = "state"
            case city = "city"
            case postalCode = "postal_code"
            case country = "country"
            case language = "language"
        }
        let addressLine1: String
        let addressLine2: String?
        let state: String
        let city: String
        let postalCode: String
        let country: String
        let language: String
    }
}
