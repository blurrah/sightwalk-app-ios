//
//  KeychainHelper.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Locksmith

class LoginPersistenceHelper {
    // Singleton instancing
    class var SharedInstance: LoginPersistenceHelper {
        struct Singleton {
            static let instance = LoginPersistenceHelper()
        }
        return Singleton.instance
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func saveToken(username: String, token: String) {
        userDefaults.setObject(username, forKey: "userNameKey")
        
        do {
            try Locksmith.saveData(["token": token], forUserAccount: username)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func accessToken(onCompletion: Void -> Void) {
        guard let name = userDefaults.stringForKey("userNameKey") else {
            print("Could not get user key")
            return
        }
        
        let dictionary = Locksmith.loadDataForUserAccount(name)
        
        // Do something with the data here
        print(dictionary)
    }
    
    func updateToken(token: String, onCompletion: Void -> Void) {
        guard let name = userDefaults.stringForKey("userNameKey") else {
            print("Could not get user key")
            return
        }
        
        do {
            try Locksmith.updateData(["token": token], forUserAccount: name)
        } catch let error as NSError {
            print(error)
        }
        
        onCompletion() // Send this to a store
    }
}