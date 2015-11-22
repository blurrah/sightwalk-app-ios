//
//  UserAPIHelper.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPIHelper {
    // Singleton instancing
    class var sharedInstance: UserAPIHelper {
        struct Singleton {
            static let instance = UserAPIHelper()
        }
        return Singleton.instance
    }
    
    let userIdentifier: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    func loginUser(username: String, password: String, onCompletion: (token: String?, error: NSError?) -> ()) {
        let parameters = [
            "username": username,
            "password": password,
            "instance_id": self.userIdentifier
        ]
        
        Alamofire.request(.POST, "\(ServerConstants.address)\(ServerConstants.User.login)", parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    let jsonResponse = JSON(response.result.value!)
                    
                    let token = jsonResponse["token"].string!
                    
                    onCompletion(token: token, error: nil)
                case .Failure(let error):
                    onCompletion(token: nil, error: error)
                }
            })
    }
    
    // TODO: Refactor parameters to use tuple/dictionary
    func registerUser(username: String, password: String, email: String, onCompletion: (token: String?, error: NSError?) -> ()) {
        let parameters = [
            "username": username,
            "password": password,
            "email": email,
            "instance_id": self.userIdentifier
        ]
        
        Alamofire.request(.POST, "\(ServerConstants.address)\(ServerConstants.User.register)", parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData({ response in
                switch response.result {
                case .Success:
                    let jsonResponse = JSON(response.result.value!)
                    
                    let token = jsonResponse["token"].string
                    
                    onCompletion(token: token, error: nil)
                case .Failure(let error):
                    onCompletion(token: nil, error: error)
                }
            })
    }
}