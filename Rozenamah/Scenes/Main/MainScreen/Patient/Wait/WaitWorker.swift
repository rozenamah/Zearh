import UIKit
import Alamofire
import KeychainAccess

typealias DoctorVisitCompletion = (VisitDetails?, RMError?) -> Void

class WaitWorker {
	
    @discardableResult
    func searchForDoctos(withFilters form: CallDoctorForm, completion: @escaping DoctorVisitCompletion) -> DataRequest? {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return nil
        }
        
        let params = form.toParams
        print(params)
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let request = Alamofire.request(API.Doctor.search.path, method: .get, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: VisitDetails.self , completion: completion)
        return request
    }
}
