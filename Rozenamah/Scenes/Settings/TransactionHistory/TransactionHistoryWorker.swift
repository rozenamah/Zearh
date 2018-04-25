import UIKit
import Alamofire

class TransactionHistoryWorker {
    typealias TransactionResponse = (([Transaction]?, RMError?)->())
    internal static let kHistoryLimit = 10
    
    func fetchTransactionHistory(for user: User, completion: @escaping TransactionResponse) {
        
        var transactions = [Transaction]()
        // TODO: Delete
        let dict: [String : Any] = [
            "dateTimestamp": 1524491346,
            "arrivalTimestamp": 1524491346,
            "leaveTimestamp": 1524492373,
            "paymentMethod": "card",
            "visit": [
                "longitude": 19.93006,
                "latitude": 50.089237,
                "address": "Krowoderskich Zuch= 14, Krak, Poland",
                "phone": "123456789",
                "fee": 0,
                "price": 150.0
            ],
            "user": [
                "id": "6b1070ea418011e892e4020000245d02",
                "email": "test1@g.com",
                "name": "Stanis",
                "surname": "Poniatowski",
                "type": "patient",
                "phone": "123456789"
            ]
        ]
        if let trans = decodeObject(toType: Transaction.self, from: dict) {
            
            for _ in 1...10 {
                transactions.append(trans)
            }
            completion(transactions, nil)
        }
        
//        // TODO: Generate valid params and headers
//        Alamofire.request(API.Transaction.history.path, method: .post, parameters: nil, headers: nil)
//            .validate()
//            .responseCodable(type: [Transaction].self, completion: completion)
    }
}


private func decodeObject<H: Decodable>(toType: H.Type, from userInfo: [String: Any]) -> H? {
    // TODO: Delete
    print(userInfo)
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let data = try decoder.decode(toType, from: jsonData)
        return data
        
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
