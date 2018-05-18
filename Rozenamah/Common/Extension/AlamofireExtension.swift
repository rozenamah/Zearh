//
//  AlamofireExtension.swift
//  Rozenamah
//
//  Created by Dominik Majda on 14.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import KeychainAccess
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
    case noData
    case status(code: StatusCode, response: ErrorResponse)
    
    var errorDescription: String? {
        switch self {
        case .unknown(let error):
            return error.localizedDescription
        case .status(let code, _) where code == .serverError:
            return "Something is wrong with our server :("
        case .status(_, let error):
            return error.message
        case .tokenDoesntExist:
            return "You need to sign in again"
        case .noData:
            return "Data not found"
        }
    }
}

extension Alamofire.DataRequest {
    
    typealias RequestCompletion = (DataRequest?) -> Void
    
    @discardableResult
    func responseEmpty(completion: @escaping ErrorCompletion, retryOnRefresh: Bool = true) -> DataRequest {
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
                if error.localizedDescription == "cancelled" {
                    return
                }
                
                // Try to unwrap message from server
                if let rmError = self.errorFrom(response: response) {
                    if retryOnRefresh {
                        // Token might be expired, if so - let try to refresh it
                        self.refreshTokenIfNeeded(byChecking: rmError, completion: { (req) in
                            if let request = req {
                                // New, refreshed request, we need to call it again
                                request.responseEmpty(completion: completion, retryOnRefresh: false)
                            } else {
                                completion(rmError)
                            }
                        })
                    } else {
                        completion(rmError)
                    }
                    
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
    func responseCodable<T: Decodable>(type: T.Type, completion: @escaping ((T?, RMError?) -> Void), retryOnRefresh: Bool = true) -> DataRequest {
        let req = responseData { (response) in
            switch response.result {
            case .success(let value):
                do {
                    if value.isEmpty {
                        completion(nil, RMError.noData) // Status might be "not found" and data will be empty
                        return
                    }
                    
                    #if DEBUG
                        if let json = String(data: value, encoding: .utf8) {
                            print("Response\n:\(json)")
                        }
                    #endif
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    completion(try decoder.decode(type, from: value), nil)
                } catch let e {
                    #if DEBUG
                        print((e as NSError).debugDescription)
                    #endif
                    
                    completion(nil, RMError.unknown(error: e))
                }
            case .failure(let error):
                if error.localizedDescription == "cancelled" {
                    return
                }
                
                // Try to unwrap message from server
                if let rmError = self.errorFrom(response: response) {
                    
                    if retryOnRefresh {
                        // Token might be expired, if so - let try to refresh it
                        self.refreshTokenIfNeeded(byChecking: rmError, completion: { (req) in
                            if let request = req {
                                // New, refreshed request, we need to call it again
                                request.responseCodable(type: type, completion: completion, retryOnRefresh: false)
                            } else {
                                completion(nil, rmError)
                            }
                        })
                    } else {
                        completion(nil, rmError)
                    }
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
                                      response: error)
            }
        }
        return nil
    }
    
    func refreshTokenIfNeeded(byChecking rmError: RMError, completion: @escaping RequestCompletion) {
        
        if case let .status(code, error) = rmError,
            code == .unauthorized,
            error.message.contains("Token") {
            
            guard let refreshToken = Keychain.shared.refreshToken else {
                completion(nil)
                return
            }
            
            let params = [
                "refresh_token": refreshToken
            ]
            
            Alamofire.request(API.User.refresh.path, method: .post, parameters: params,
                              encoding: JSONEncoding.default)
                .validate()
                .responseData { (response) in
                    
                    switch response.result {
                    case .success(_):
                        if let urlRequest = self.request {
                            let request = Alamofire.request(urlRequest)
                            completion(request)
                        }

                    case .failure(_):
                        completion(nil)
                    }
            }
        } else {
            completion(nil)
        }
        
    }
}
