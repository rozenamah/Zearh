import UIKit
import Alamofire
import KeychainAccess

typealias BookingsCompletion = ((TransactionHistory?, Error?)->())

class TransactionHistoryWorker {
   
    /// Fetches list of all users
    func fetchTransactionHistory(builder: TransactionHistoryBuilder, completion: @escaping BookingsCompletion) {
        
        let params = builder.toParams
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        
        Alamofire.request(API.Visit.history.path, method: .get, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: TransactionHistory.self, completion: completion)
    }
}
