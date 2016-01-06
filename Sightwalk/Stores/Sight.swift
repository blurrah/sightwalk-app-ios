//
//  Sight.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 03/12/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Sight: Comparable, Hashable {
    
    let id: Int
    var type: String
    var location: CLLocationCoordinate2D
    var name: String
    var title:String
    var text: String
    var imgurl: String
    var shortdesc: String
    
    var hashValue : Int {
        get {
            return id
        }
    }
    
    var userPriority: Int?
    
    init(id: Int, type: String, location: CLLocationCoordinate2D, name: String, title: String, text: String, imgurl: String, shortdesc: String) {
        self.id = id
        self.type = type
        self.location = location
        self.name = name
        self.title = title
        self.text = text
        self.imgurl = imgurl
        self.shortdesc = shortdesc
    }
    
    convenience init(data : JSON) {
        self.init(
            id: data["id"].int!,
            type: data["type"].string!,
            location: CLLocationCoordinate2D(latitude: data["latitude"].double!, longitude: data["longitude"].double!),
            name: data["name"].string!,
            title: data["title"].string!,
            text: data["description"].string!,
            imgurl: data["image_url"].string!,
            shortdesc: data["short_description"].string!
        )
    }
    
    func changePriority(newPriority: Int) {
        self.userPriority = newPriority
    }
    
    func isFurtherThan(point : CLLocation, distance : Int) -> Bool {
        return Int(point.distanceFromLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))) < distance
    }
    
    func dataEquals(sight : Sight) -> Bool {
        return
            type == sight.type
            && name == sight.name
            && title == sight.title
            && text == sight.text
            && imgurl == sight.imgurl
            && shortdesc == sight.shortdesc
    }
    
    func commit(sight : Sight) {
        type = sight.type
        location = sight.location
        name = sight.name
        title = sight.title
        text = sight.text
        imgurl = sight.imgurl
        shortdesc = sight.shortdesc
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