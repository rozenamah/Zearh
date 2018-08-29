import UIKit

enum Payment {
    class Details: Decodable {
        private enum CodingKeys : String, CodingKey {
            case billingAddress = "billing_address"
            case state = "state"
            case city = "city"
            case postalCode = "postal_code"
            case country = "country"
//            case language = "language"
        }
        let billingAddress: String
        let state: String
        let city: String
        let postalCode: String
        let country: String
//        let language: String
    }
}
