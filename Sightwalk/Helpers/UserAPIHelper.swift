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
    
    func loginUser(username: String, password: String, onCompletion: (JSON) -> Void) {
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, ServerConstants.address + ServerConstants.User.login, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData({ response in
                print(response.request)
                
                let jsonResponse = JSON(response.result.value!)
                
                onCompletion(jsonResponse)
            })
    }
}