//
//  ServerConstants.swift
//  Sightwalk
//
//  Created by Boris Besemer on 16-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

struct ServerConstants {
    static let address = "http://sightwalk.net/"
    
    struct User {
        static let login = "auth/login/"
        static let logout = "auth/logout/"
        static let register = "user/"
        static let passwordreset = "auth/password-reset"
    }
}

struct GoogleConstants {
    static let key = "AIzaSyC3coo4P05aqogBOw9ocwoxXVRktR0_Abg"
    
    struct Directions {
        static let url = "https://maps.googlemaps.com/maps/api/directions/json"
    }
}