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
    
    var apiResponse: JSON?
    
    var chosenRoute: String?
    
    func calculateTotalDistance() -> String {
        var distance: Double = 0
        for (_, subJson) in apiResponse!["routes"][0]["legs"] {
            if let currentDistance = subJson["distance"]["value"].double {
                distance = distance + currentDistance
            }
        }
        
        distance = distance / 1000
        
        return String(format: "%.1f", distance)
    }
    
    func calculateTotalTime() -> (Int, Int, Int) {
        var time: Int = 0
        
        for (_, subJson) in apiResponse!["routes"][0]["legs"] {
            if let currentTime = subJson["duration"]["value"].int {
                time = time + currentTime
            }
        }
        
        return (time / 3600, (time % 3600) / 60, (time % 3600) % 60)
    }
}