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
    
    private let context : NSManagedObjectContext
    private let appDelegate : AppDelegate
    
    class var sharedInstance: RouteStore {
        struct Singleton {
            static let instance = RouteStore()
        }
        return Singleton.instance
    }
    
    var activities = [NSManagedObjectID : Activity]()
    
    init() {
        print(" loaded routestore")
        
        // get context
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
    }
    
    func saveContext() {
        activities = [:]
        appDelegate.saveContext()
    }
    
    func newActivity() -> Activity {
        return NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: context) as! Activity
    }
    
    func newDummyActivity() -> Activity {
        let newActivity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: context)
        let dummyActivity = NSManagedObject(entity: newActivity!, insertIntoManagedObjectContext: appDelegate.tmpContext) as! Activity
        return dummyActivity
    }
    
    func removeActivity(activity : Activity) {
        activities = [:]
        context.deleteObject(activity as NSManagedObject)
        appDelegate.saveContext()
    }
    
    func getAllActivities() -> [Activity] {
        if activities.count == 0 {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
        
            let fetchRequest = NSFetchRequest(entityName: "Activity");
        
            do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Activity]
                for act in fetchResults! {
                    activities[act.getId()] = act
                }
            } catch let error as NSError {
                debugPrint(error)
            }
        }
    
        return Array(activities.values)
    }
}