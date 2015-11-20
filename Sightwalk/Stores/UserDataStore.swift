//
//  UserDataStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

class UserDataStore {
    // Singleton instancing
    class var sharedInstance: UserDataStore {
        struct Singleton {
            static let instance = UserDataStore()
        }
        return Singleton.instance
    }
    
    var username: String?
    var token: String?
    
    let userAPIHelper = UserAPIHelper.sharedInstance
    let loginPersistenceHelper = LoginPersistenceHelper.SharedInstance
    
    func getNewToken(username: String, password: String, onCompletion: (success: Bool, message: String?) -> ()) {
        self.userAPIHelper.loginUser(username, password: password, onCompletion: { token, error in
            guard error != nil else {
                onCompletion(success: false, message: "API Request errored: \(error)")
                return
            }
            
            self.token = token!
            self.username = username
            
            self.loginPersistenceHelper.saveToken(username, token: token!)
        })
    }
    
    func registerToken(username: String, password: String, email: String, onCompletion: (success: Bool, message: String?) -> ()) {
        self.userAPIHelper.registerUser(username, password: password, email: email, onCompletion: { token, error in
            guard error != nil else {
                onCompletion(success: false, message: "API Request errored: \(error)")
                return
            }
            
            self.token = token!
            self.username = username
            
            self.loginPersistenceHelper.saveToken(username, token: token!)
            
            onCompletion(success: true, message: nil)
        })
    }
    
    func deleteToken() {
        self.loginPersistenceHelper.deleteToken(self.username!)
        self.token = nil
    }
}