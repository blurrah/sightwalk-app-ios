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
                    
                    let success = jsonResponse["success"].bool!
                    
                    guard success == true else {
                        let errorObject = self.createErrorObject(jsonResponse["error"].int!)
                        
                        onCompletion(token: nil, error: errorObject)
                        return
                    }
                    
                    let token = jsonResponse["token"].string!
                    
                    onCompletion(token: token, error: nil)
                case .Failure(let error):
                    onCompletion(token: nil, error: error)
                }
            })
    }
    
    func resetPassword(email: String, onCompletion: (success: Bool, error: NSError?) -> ()) {
        let parameters: [String: AnyObject] = [
            "email": email
        ]
        
        Alamofire.request(.POST, "\(ServerConstants.address)\(ServerConstants.User.passwordreset)", parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    let jsonResponse = JSON(response.result.value!)
                    
                    let success = jsonResponse["success"].bool!
                    
                    guard success == true else {
                        let error = jsonResponse["error"].int!
                        let errorObject = self.createErrorObject(error)
                        
                        onCompletion(success: false, error: errorObject)
                        return
                    }
                    
                    onCompletion(success: true, error: nil)
                case .Failure(let error):
                    print("hij is gefaald! met \(error.localizedDescription)")
                    onCompletion(success: false, error: error)
                }
            })

        
    }
    
    // TODO: Refactor parameters to use tuple/dictionary
    func registerUser(username: String, password: String, email: String, weight: Int, length: Int, birthdate: String, onCompletion: (success: Bool, error: NSError?) -> ()) {
        let parameters: [String: AnyObject] = [
            "username": username,
            "password": password,
            "email": email,
            "firstname": "Jeroen",
            "lastname": "van GHBDoorn",
            "weight": weight,
            "length": length,
            "birthdate": birthdate
        ]
        
        Alamofire.request(.POST, "\(ServerConstants.address)\(ServerConstants.User.register)", parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    let jsonResponse = JSON(response.result.value!)
                    
                    let success = jsonResponse["success"].bool!
                    
                    guard success == true else {
                        let error = jsonResponse["error"].int!
                        let errorObject = self.createErrorObject(error)
                        
                        onCompletion(success: false, error: errorObject)
                        return
                    }
                    
                    onCompletion(success: true, error: nil)
                case .Failure(let error):
                    print("hij is gefaald! met \(error.localizedDescription)")
                    onCompletion(success: false, error: error)
                }
            })
    }
    
    private func createErrorObject(code: Int) -> NSError {
        let errorDetail:NSMutableDictionary = NSMutableDictionary()
        
        switch code {
        case -1:
            errorDetail.setValue("Onbekende fout opgetreden.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: -1, userInfo: errorDetail as [NSObject : AnyObject])
        case 1:
            errorDetail.setValue("Inloggegevens kloppen niet.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 1, userInfo: errorDetail as [NSObject : AnyObject])
        case 3:
            errorDetail.setValue("E-mailadres klopt niet (is deze al in gebruik?).", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 3, userInfo: errorDetail as [NSObject : AnyObject])
        case 4:
            errorDetail.setValue("Wachtwoord klopt niet.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 4, userInfo: errorDetail as [NSObject : AnyObject])
        case 5:
            errorDetail.setValue("Gebruikersnaam is al in gebruik.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 5, userInfo: errorDetail as [NSObject : AnyObject])
        case 6:
            errorDetail.setValue("Gewicht klopt niet.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 6, userInfo: errorDetail as [NSObject : AnyObject])
        case 7:
            errorDetail.setValue("Lengte klopt niet.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 7, userInfo: errorDetail as [NSObject : AnyObject])
        case 8:
            errorDetail.setValue("Geboortedatum klopt niet.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: 8, userInfo: errorDetail as [NSObject : AnyObject])
        default:
            errorDetail.setValue("Onbekende fout opgetreden.", forKey: NSLocalizedDescriptionKey)
            return NSError(domain: "net.sightwalk.error", code: -1, userInfo: errorDetail as [NSObject : AnyObject])
        }
    }
}