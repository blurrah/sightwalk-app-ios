//
//  ServerConstants.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

struct ServerConstants {
    static let address = "https://sightwalk.net/"
    
    struct User {
        static let login = "auth/login/"
        static let logout = "auth/logout/"
        static let register = "user/"
        static let passwordreset = "auth/password-reset"
    }
    
    struct Sight {
        static let getInRange = "sight/"
        static let store = "sight/"
    }
}

struct GoogleConstants {
    static let key = "AIzaSyC3coo4P05aqogBOw9ocwoxXVRktR0_Abg"
    static let webKey = "AIzaSyBnSNdHfYjzL_fwVgXZ5DQvZcymoticEqE"
    
    struct Directions {
        static let url = "https://maps.googleapis.com/maps/api/directions/json"
    }
}