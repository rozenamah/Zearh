import UIKit
import KeychainAccess
import Alamofire

class ReportWorker {
    
    func reportDoctor(_ reportForm: ReportForm, completion: @escaping ErrorCompletion) {
        
        let params = reportForm.toParams
        
        Alamofire.request(API.User.changePassword.path, method: .post, parameters: params)
            .validate()
            .responseEmpty(completion: completion)
        
    }
}
