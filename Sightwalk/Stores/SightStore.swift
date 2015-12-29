//
//  SightStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 10-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class SightStore : SightSyncInterface {
    class var sharedInstance: SightStore {
        struct Singleton {
            static let instance = SightStore()
        }
        return Singleton.instance
    }
    
    private var subscribers : [String : SightManager] = [:]
    private var sightSyncer : SightSyncer? = nil
    
    
    init() {
        sightSyncer = SightSyncer(client: self)

    }
    
    func subscribe(subscriber : SightManager, slot : String) {
        subscribers[slot] = subscriber
    }
    
    func unsubscribe(slot : String) {
        subscribers.removeValueForKey(slot)
    }
    
    func getAll(subscriber : SightManager) {
        for sight : Sight in sights {
            subscriber.addSight(sight)
        }
    }
    
    func subscribeAndGet(subscriber : SightManager, slot : String) {
        subscribe(subscriber, slot: slot)
        getAll(subscriber)
    }
    
    func markSightSelected(sight : Sight) {
        markSightSelected(sight, selected: true)
    }
    
    func markSightSelected(sight : Sight, selected : Bool) {
        // add marker
        if selected && !userChosen.contains(sight) {
            userChosen.append(sight)
        }
        
        // remove marker
        if !selected && userChosen.contains(sight) {
            userChosen.removeAtIndex(userChosen.indexOf(sight)!)
        }
    }
    
    func isSelected(sight : Sight) -> Bool {
        return userChosen.contains(sight)
    }
    
    func getAllSights() -> [Sight] {
        return sights
    }
    
    func markSightAsFavorite(sight : Sight) {
        markSightAsFavorite(sight, favorite: true)
    }
    
    func markSightAsFavorite(sight : Sight, favorite : Bool) {
        if favorite && !favorites.contains(sight) {
            favorites.append(sight)
            storeFavorite(sight.id)
        }
        
        if !favorite && favorites.contains(sight) {
            favorites.removeAtIndex(favorites.indexOf(sight)!)
            removeFavorite(sight.id)
        }
    }
    
    func isFavorite(sight : Sight) -> Bool {
        return favorites.contains(sight)
    }
    
    func triggerRemoveSight(sight : Sight) {
        print("trigger remove")
    }
    func triggerAddSight(sight : Sight) {
        print("trigger add")
    }
    
    
    func storeFavorite(id: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if let entry = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: context) as? Favorite {
            entry.id = id
            appDelegate.saveContext()
        }
    }
    
    func removeFavorite(id: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Favorite");
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Favorite]
            if let i = fetchResults!.indexOf({$0.id == id}) {
                context.deleteObject(fetchResults![i])
                appDelegate.saveContext()
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func getAllFavorites() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Favorite");
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Favorite]
            for fav in fetchResults! {
                if let i = sights.indexOf({$0.id == fav.id!}) {
                    if !favorites.contains(sights[i]) {
                        favorites.append(sights[i])
                    }
                }
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    var sights = [Sight]()
    var userChosen = [Sight]()
    var favorites = [Sight]()
    var endPoint = String()
    var origin = String()
}