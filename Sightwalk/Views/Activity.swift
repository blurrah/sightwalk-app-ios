//
//  Activity.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 10/01/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Activity: NSManagedObject {
    
    var jsonInfo : JSON?
    var polylines : [Int: [String]]?
    var directions: [Int: [String]]?
    var sights: [Sight]?
    
    func getId() -> NSManagedObjectID {
        return self.objectID
    }
    
    func getSights() -> [Sight] {
        if sights != nil {
            return sights!
        }
        
        let selection : [Int] = self.userChosen.characters.split{$0 == "-"}.map(String.init).map({ Int($0) ?? -1 })
        sights = SightStore.sharedInstance.getSelection(selection)
        return sights!
    }
    
    func setSights(sights : [Sight]) {
        self.sights = sights
        self.userChosen = sights.map({ String($0.id) }).joinWithSeparator("-")
        print(self.userChosen)
    }
    
    func getRouteInfo() -> JSON {
        if jsonInfo != nil {
            return jsonInfo!
        }
        
        if let dataFromString = self.jsonResponse.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            jsonInfo = JSON(data: dataFromString)
        } else {
            jsonInfo = JSON([])
        }
        
        return jsonInfo!
    }
    
    func setRouteInfo(info : JSON) {
        if let s = info.rawString() {
            jsonResponse = s
            jsonInfo = info
            polylines = nil
            directions = nil
        }
    }
    
    func getDirections() -> [Int : [String]] {
        if directions != nil {
            return directions!
        }
        
        // parse directions
        directions = [:]
        let info : JSON = getRouteInfo()
        let length = info["routes"][0]["legs"].count
        
        for (var i = 0; i <= length; i++) {
            for (_, subJson) in info["routes"][0]["legs"][i]["steps"] {
                let direction = subJson["html_instructions"].string!
                if var arr = directions![i] {
                    arr.append(direction)
                    
                    directions![i] = arr
                } else {
                    directions![i] = [direction]
                }
            }
        }

        return directions!
    }
    
    func getPolylines() -> [Int : [String]] {
        if polylines != nil {
            return polylines!
        }
        
        // parse polylines
        polylines = [:]
        let info : JSON = getRouteInfo()
        let length = info["routes"][0]["legs"].count
        for (var i = 0; i <= length; i++) {
            for (_, subJson) in info["routes"][0]["legs"][i]["steps"] {
                let polyline = subJson["polyline"]["points"].string!
                if var arr = polylines![i] {
                    arr.append(polyline)
                    polylines![i] = arr
                } else {
                    polylines![i] = [polyline]
                }
            }
        }
        
        return polylines!
    }
    
    func getTotalDistance() -> String {
        var distance: Double = 0
        let info : JSON = getRouteInfo()
        
        for (_, subJson) in info["routes"][0]["legs"] {
            if let currentDistance = subJson["distance"]["value"].double {
                distance = distance + currentDistance
            }
        }
        
        distance = distance / 1000

        return String(format: "%.1f", distance)
    }
    
    func getTotalTime() -> (Int, Int, Int) {
        var time: Int = 0
        let info : JSON = getRouteInfo()
        
        for (_, subJson) in info["routes"][0]["legs"] {
            if let currentTime = subJson["duration"]["value"].int {
                time = time + currentTime
            }
        }
        
        return (time / 3600, (time % 3600) / 60, (time % 3600) % 60)
    }
    
    func setDate() {
        setDate(NSDate())
    }
    
    func setDate(date : NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        dateTime = dateFormatter.stringFromDate(date)
    }
    
    func getDate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        let date = dateFormatter.dateFromString(dateTime)
        if date != nil {
            return date!
        }
        return NSDate()
    }
    
    func duplicateInto(newActivity : Activity) {
        newActivity.userChosen = userChosen
        newActivity.jsonResponse = jsonResponse
        newActivity.name = name
        newActivity.dateTime = dateTime
    }
    
    func readyForWalking() -> Bool {
        print(userChosen)
        return userChosen.characters.count > 0
    }
    
    func switchPosition(sightOne : Sight, sightTwo : Sight) {
        if isSelected(sightOne) && isSelected(sightTwo) {
            let posOne : Int = getSelectedIndex(sightOne)!
            let posTwo : Int = getSelectedIndex(sightTwo)!
            
            var sights : [Sight] = getSights()
            sights[posOne] = sightTwo
            sights[posTwo] = sightOne
            setSights(sights)
        }
    }
    
    func isSelected(sight : Sight) -> Bool {
        return getSights().contains(sight)
    }
    
    func getSelectedIndex(sight : Sight) -> Int? {
        return getSights().indexOf(sight)
    }
    
    func getSelectedCount() -> Int {
        return getSights().count
    }
    
    func hasSelectedSights() -> Bool {
        return !getSights().isEmpty
    }
    
    func markSightSelected(sight : Sight) {
        markSightSelected(sight, selected: true)
    }
    
    func markSightSelected(sight : Sight, selected : Bool) {
        var sights : [Sight] = getSights()
        
        // add marker
        if selected && !sights.contains(sight) {
            sights.append(sight)
        }
        
        // remove marker
        if !selected && sights.contains(sight) {
            sights.removeAtIndex(sights.indexOf(sight)!)
        }
        
        setSights(sights)
    }
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }
