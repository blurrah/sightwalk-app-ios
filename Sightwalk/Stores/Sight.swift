//
//  Sight.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 03/12/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation

class Sight: Comparable {
    
    let id: Int
    let type: String
    let location: CLLocationCoordinate2D
    let name: String
    let title:String
    let text: String
    let imgurl: String
    
    var chosen: Bool = false
    var userPriority: Int?
    
    init(id: Int, type: String, location: CLLocationCoordinate2D, name: String, title: String, text: String, imgurl: String) {
        self.id = id
        self.type = type
        self.location = location
        self.name = name
        self.title = title
        self.text = text
        self.imgurl = imgurl
    }
    
    func changeState() {
        self.chosen = !self.chosen
    }
    
    func changePriority(newPriority: Int) {
        self.userPriority = newPriority
    }
}

func >(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.userPriority > rhs.userPriority
}

func <(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.userPriority < rhs.userPriority
}

func ==(lhs: Sight, rhs: Sight) -> Bool {
    return lhs.id == rhs.id
}