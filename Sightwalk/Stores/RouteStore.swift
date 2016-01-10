//
//  RouteStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class RouteStore {
    class var sharedInstance: RouteStore {
        struct Singleton {
            static let instance = RouteStore()
        }
        return Singleton.instance
    }
    
    var activities = [Activity]()
    var apiResponse: JSON?
    var routeName: String?
    var chosenRoute: String?
    
    var polylines: [Int: [String]] = [:]
    var directions: [Int: [String]] = [:]
    
    init() {
        print(" loaded routestore")
    }
    
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
    
    func setPolylines() {
        polylines = [:]
        
        let length = apiResponse!["routes"][0]["legs"].count
        
        for (var i = 0; i <= length; i++) {
            for (_, subJson) in apiResponse!["routes"][0]["legs"][i]["steps"] {
                let polyline = subJson["polyline"]["points"].string!
                if var arr = polylines[i] {
                    arr.append(polyline)
                    polylines[i] = arr
                } else {
                    polylines[i] = [polyline]
                }
            }
        }
        print(polylines)
    }
    
    func setDirections() {
        directions = [:]
        
        let length = apiResponse!["routes"][0]["legs"].count
        
        for (var i = 0; i <= length; i++) {
            for (_, subJson) in apiResponse!["routes"][0]["legs"][i]["steps"] {
                let direction = subJson["html_instructions"].string!
                if var arr = directions[i] {
                    arr.append(direction)
                    
                    directions[i] = arr
                } else {
                    directions[i] = [direction]
                }
            }
        }
        print(directions)
    }
    
    func storeActivity(id: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if let entry = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: context) as? Activity {
            entry.name = self.routeName!
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
            let dateString = dateFormatter.stringFromDate(date)
            
            entry.dateTime = dateString
            entry.jsonResponse = self.apiResponse!.rawString()!
            var array = [String]()

            for uc in SightStore.sharedInstance.userChosen {
                array.append(String(uc.id))
            }
            entry.userChosen = array.joinWithSeparator("-")
            appDelegate.saveContext()
        }
    }
    
    func removeActivity(id: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Activity");
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Activity]
            if let i = fetchResults!.indexOf({$0.id == id}) {
                context.deleteObject(fetchResults![i])
                appDelegate.saveContext()
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func getAllActivities() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Activity");
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Activity]
            for act in fetchResults! {
                if !activities.contains(act) {
                    activities.append(act)
                }
                activities = activities.reverse()
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}