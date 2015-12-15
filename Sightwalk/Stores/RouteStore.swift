//
//  RouteStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import SwiftyJSON

class RouteStore {
    class var sharedInstance: RouteStore {
        struct Singleton {
            static let instance = RouteStore()
        }
        return Singleton.instance
    }
    
    var chosenRoute: String?
}