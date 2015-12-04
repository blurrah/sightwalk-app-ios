//
//  Sight.swift
//  Sightwalk
//
//  Created by Boris Besemer on 04-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

class Sight: Comparable {
    let name: String
    let description: String
    let lat: Double
    let lon: Double
    
    var enabled: Bool?
    var userPriority: Int?
    
    init(name: String, description: String, lat: Double, lon: Double) {
        self.name = name
        self.description = description
        self.lat = lat
        self.lon = lon
    }
    
    func changeState(state: Bool) {
        self.enabled = state
    }
    
    func changePrio(priority: Int) {
        self.userPriority = priority
    }
    
}

// Comparable & Equatable protocol functions
func >(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.userPriority > rhs.userPriority
}

func <(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.userPriority < rhs.userPriority
}

func ==(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.name == rhs.name
}

