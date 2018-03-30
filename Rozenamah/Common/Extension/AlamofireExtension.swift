//
//  AlamofireExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 14.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import Alamofire

enum RMError: LocalizedError {
    
    enum StatusCode: Int {
        case unauthorized = 401
        case badRequest = 400
        case forbidden = 403
        case notFound = 404
        case duplicate = 409
        case serverError = 500
    }
    
    case unknown(error: Error)
    case tokenDoesntExist
    case status(code: StatusCode, msg: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown(let error):
            return error.localizedDescription
        case .status(let code, _) where code == .serverError:
            return "Something is wrong with our server :("
        case .status(_, let msg):
            return msg
        case .tokenDoesntExist:
            return "You need to sign in again"
        }
    }
}

extension Alamofire.DataRequest {
    
    @discardableResult
    func responseEmpty(completion: @escaping ErrorCompletion) -> DataRequest {
        let req = responseData { (response) in
            switch response.result {
            case .success(let value):
                #if DEBUG
                    if let json = String(data: value, encoding: .utf8) {
                        print("Response empty\n\(json)")
                    }
                #endif
                completion(nil) // No error
            case .failure(let error):
                // Try to unwrap message from server
                if let rmError = self.errorFrom(response: response) {
                    completion(rmError)
                    return
                }
                
                completion(RMError.unknown(error: error))
            }
        }
        #if DEBUG
            debugPrint(req)
        #endif
        return req
    }
    
    @discardableResult
    func responseCodable<T: Decodable>(type: T.Type, completion: @escaping ((T?, RMError?) -> Void)) -> DataRequest {
        let req = responseData { (response) in
            switch response.result {
            case .success(let value):
                do {
                    #if DEBUG
                        if let json = String(data: value, encoding: .utf8) {
                            print("Response\n:\(json)")
                        }
                    #endif
                    let decoder = JSONDecoder()
                    completion(try decoder.decode(type, from: value), nil)
                } catch let e {
                    completion(nil, RMError.unknown(error: e))
                }
            case .failure(let error):
                // Try to unwrap message from server
                if let rmError = self.errorFrom(response: response) {
                    completion(nil, rmError)
                    return
                }
                
                completion(nil, RMError.unknown(error: error))
            }
        }
        #if DEBUG
            debugPrint(req)
        #endif
        return req
    }
    
    private func errorFrom(response: DataResponse<Data>) -> RMError? {
        let decoder = JSONDecoder()
        if let responseData = response.data {
            
            #if DEBUG
                if let json = String(data: responseData, encoding: .utf8) {
                    print(json)
                }
            #endif
            
            if let error = try? decoder.decode(ErrorResponse.self, from: responseData),
                let status = response.response?.statusCode,
                let code = RMError.StatusCode(rawValue: status) {
                
                return RMError.status(code: code,
                                               msg: error.message)
            }
        }
        return nil
    }
}
