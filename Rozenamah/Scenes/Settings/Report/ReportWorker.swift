import UIKit
import KeychainAccess
import Alamofire

class ReportWorker {
    
    func reportDoctor(_ reportForm: ReportForm, completion: @escaping ErrorCompletion) {
        
        let params = reportForm.toParams
        
        Alamofire.request(API.User.report.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseEmpty(completion: completion)
        
    }
}
