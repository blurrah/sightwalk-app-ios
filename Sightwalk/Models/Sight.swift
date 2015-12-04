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
    var userPriority: Int?
    let description: String
    
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
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