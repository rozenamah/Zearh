import UIKit
import KeychainAccess
import Alamofire

class ReportWorker {
    
    func reportDoctor(_ reportForm: ReportForm, completion: @escaping ErrorCompletion) {
        
        let params = reportForm.toParams
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Report.create.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
        
    }
}
