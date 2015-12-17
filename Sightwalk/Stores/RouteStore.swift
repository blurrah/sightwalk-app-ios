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
    
    func calculateTotalDuration() -> String {
        var duration: Int = 0
        for (_, subJson) in apiResponse!["routes"][0]["legs"] {
            if let currentDuration = subJson["duration"]["value"].int {
                duration = duration + currentDuration
            }
        }
        
        let mins = duration / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = duration % 60
        
        if (days != 0) {
            let totalDuration = "\(days)d \(remainingHours)u \(remainingMins)m \(remainingSecs)s"
            return String(totalDuration)
        } else if (remainingHours != 0) {
            let totalDuration = "\(remainingHours)u \(remainingMins)m \(remainingSecs)s"
            return String(totalDuration)
        } else {
            let totalDuration = "\(remainingMins)m \(remainingSecs)s"
            return String(totalDuration)
        }
    }
}