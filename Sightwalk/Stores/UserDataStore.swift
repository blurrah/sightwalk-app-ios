//
//  UserDataStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

class UserDataStore {
    class var sharedInstance: UserDataStore {
        struct Singleton {
            static let instance = UserDataStore()
        }
        return Singleton.instance
    }
    
    var username: String?
    var token: String?
    
    func getNewToken(username: String, password: String) {
        
        // Send data to API
        
        // Get token back
        let token = "testtokenplsdontkillme"
        
        self.token = token
        
        // When correct: Store username in variable
        self.username = username
        
        // When correct: Store data in keychain and user defaults
        LoginPersistenceHelper.SharedInstance.saveToken(username, token: token)
    }
}