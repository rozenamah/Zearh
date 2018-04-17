import UIKit
import Alamofire
import KeychainAccess


class WaitWorker {
	
    @discardableResult
    func searchForDoctos(withFilters form: CallDoctorForm, completion: @escaping UserCompletion) -> DataRequest? {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return nil
        }
        
        let params = form.toParams
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let request = Alamofire.request(API.Doctor.search.path, method: .get, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: User.self , completion: completion)
        return request
    }
}
