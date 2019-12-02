import UIKit
import Alamofire

//TODO: This class uses our test integration server; please adapt it to use your own backend API.
class Request: NSObject {
    
    // Test merchant server domain
    static let serverDomain = "https://test.oppwa.com/v1/checkouts"
    static func requestCheckoutID(amount: Double, currency: String, completion: @escaping (String?) -> Void) {
        
        
        // new uncomment notification url
        let params: [String:String] = [
            "amount": String(format: "%.2f", amount),
            "currency": currency,
            // Store notificationUrl on your server to change it any time without updating the app.
            "notificationUrl": "https://test.oppwa.com/notification",
            "paymentType": "DB",
//            "paymentType": "PA",
            "testMode": "EXTERNAL",
            "entityId": "8a8294174d0595bb014d05d82e5b01d2"
        ]

        let headers = [
            "Authorization":"Bearer OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA=="
        ]

//        let ur = URL.init(string: "\(serverDomain)/token?")
        
        Alamofire.request(serverDomain, method: .post, parameters: params, headers:headers).responseJSON { (response) in
            print(response)
//            SVProgressHUD.dismiss()
            if response.result.isSuccess == true{
                if let JSON = response.result.value {
                    if let dictionary = JSON as? [String: Any] {
//                        if let isSuccess = dictionary["success"] as? Bool {
                            let checkoutID = dictionary["id"] as? String
                            completion(checkoutID)
//                        }
                    }
                    else {
                        completion(nil)
                    }
                }
            }
        }

//        let parameters: [String:String] = [
//            "amount": String(format: "%.2f", amount),
//            "currency": currency,
//            // Store notificationUrl on your server to change it any time without updating the app.
////            "notificationUrl": serverDomain + "/notification",
//            "paymentType": "DB",
////            "testMode": "INTERNAL",
//            "entityId": "8a8294174d0595bb014d05d82e5b01d2",
//            "Authorization": "Bearer OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA=="
//        ]
//        var parametersString = ""
//        for (key, value) in parameters {
//            parametersString += key + "=" + value + "&"
//        }
//        parametersString.remove(at: parametersString.index(before: parametersString.endIndex))
//
//        let url = serverDomain + "/token?" + parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////        let url = serverDomain + "/?" + parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let request = NSURLRequest(url: URL(string: url)!)
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                let checkoutID = json?["checkoutId"] as? String
//                completion(checkoutID)
//            } else {=
//                completion(nil)
//            }
//        }.resume()
    }
    
    
    static func newRequestCheckoutID(amount: Double, transID:String, firstName:String, lastName:String, email:String, city:String, state:String, country:String, postCode:String, street:String, completion: @escaping (String?) -> Void) {
        let params: [String:Any] = [
            "amount": String(format: "%.2f", amount),
            "givenName": firstName,
            "surname": lastName,
            "email": email,
            "city": city,
            "state": state,
            "country": country,
            "postcode": postCode,
            "street1": street
        ]
        print(params)
        
        Alamofire.request("https://zearh-api.rozenamah.com/api/payment/checkout", method: .post, parameters: params).responseJSON { (response) in
            print(response)
            if response.result.isSuccess == true{
                if let JSON = response.result.value {
                    if let dictionary = JSON as? [String: Any] {
                        let checkoutID = dictionary["checkout_id"] as? String
                        completion(checkoutID)
                    }
                    else {
                        completion(nil)
                    }
                }
            }
        }
    }

    
    static func requestPaymentStatus(resourcePath: String, vc:UIViewController, completion: @escaping (Bool, String) -> Void) {
        
        let url = "https://test.oppwa.com/" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let params: [String:String] = [
            "entityId": "8a8294174d0595bb014d05d82e5b01d2"
        ]
        
        let headers = [
            "Authorization":"Bearer OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA=="
        ]
        
        Alamofire.request(url, method: .get, parameters: params, headers:headers).responseJSON { (response) in
            print(response)
            if response.result.isSuccess == true{
                if let JSON = response.result.value {
                    if let dictionary = JSON as? [String: Any] {
                        if let transactionStatus = dictionary["result"] as? [String:String] {
                            let msg = transactionStatus["description"] as! String
                            if transactionStatus["code"] == "000.100.110" {
                                completion(true,msg)
                            } else {
                                completion(true,msg)
                            }
                        }
                    }
                    else {
                        completion(false,"")
                    }
                }
            }
        }

        
        
        
        
        
////        let url = serverDomain + "/paymentStatus?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let url = "https://test.oppwa.com" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "?entityId=8a8294174d0595bb014d05d82e5b01d2"
//        print(url)
////        let url = "https://test.oppwa.com" + "/status?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////        let url = serverDomain + "/paymentStatus?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let request = NSURLRequest(url: URL(string: url)!)
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                let transactionStatus = json?["paymentResult"] as? String
//                completion(transactionStatus == "OK")
//            } else {
//                completion(false)
//            }
//        }.resume()
//
        
//        let url = String(format: "\(serverDomain)/paymentStatus?resourcePath=%@", resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//        print(url)
//        let merchantServerRequest = NSURLRequest(url: URL(string: url)!)
//        URLSession.shared.dataTask(with: merchantServerRequest as URLRequest) { (data, response, error) in
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                let transactionStatus = json?["paymentResult"] as? Bool
//            }
//            }.resume()
    }
    
    
    static func newRequestPaymentStatus(checkoutID: String, vc:UIViewController, completion: @escaping (Bool, String) -> Void) {
        
        let url = "https://zearh-api.rozenamah.com/api/payment/status"
        
        let params: [String:String] = [
            "checkout_id": "\(checkoutID)"
        ]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            print(response)
            if response.result.isSuccess == true{
                if let JSON = response.result.value {
                    if let dictionary = JSON as? [String: Any] {
                        if let transactionStatus = dictionary["result"] as? [String:String] {
                            let msg = transactionStatus["description"] as! String
                            let code = transactionStatus["code"] ?? ""
                            
                            let result = code.range(of: "^(000\\.000\\.|000\\.100\\.1|000\\.[36])", options: .regularExpression) != nil
                            
                            
                            if result {
                                completion(true,msg)
                            } else {
                                completion(false,msg)
                            }
                        }
                    }
                    else {
                        completion(false,"")
                    }
                }
            }
        }
        
        
        
        
        
        
        ////        let url = serverDomain + "/paymentStatus?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //        let url = "https://test.oppwa.com" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "?entityId=8a8294174d0595bb014d05d82e5b01d2"
        //        print(url)
        ////        let url = "https://test.oppwa.com" + "/status?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ////        let url = serverDomain + "/paymentStatus?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //        let request = NSURLRequest(url: URL(string: url)!)
        //        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        //            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        //                let transactionStatus = json?["paymentResult"] as? String
        //                completion(transactionStatus == "OK")
        //            } else {
        //                completion(false)
        //            }
        //        }.resume()
        //
        
        //        let url = String(format: "\(serverDomain)/paymentStatus?resourcePath=%@", resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        //        print(url)
        //        let merchantServerRequest = NSURLRequest(url: URL(string: url)!)
        //        URLSession.shared.dataTask(with: merchantServerRequest as URLRequest) { (data, response, error) in
        //            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        //                let transactionStatus = json?["paymentResult"] as? Bool
        //            }
        //            }.resume()
    }

}
