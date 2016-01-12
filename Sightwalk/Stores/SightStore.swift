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
import JLToast

class SightStore : SightSyncInterface {
    class var sharedInstance: SightStore {
        struct Singleton {
            static let instance = SightStore()
        }
        return Singleton.instance
    }
    
    private var subscribers : [String : SightManager] = [:]
    private var sightSyncer : SightSyncer?
    private let sqlh : SQLiteHelper
    private var hasShown : Bool = false
    
    init() {
        print(" loaded sightstore")
        
        sqlh = SQLiteHelper.sharedInstance
        
        sightSyncer = SightSyncer(client: self)

        loadSights()
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
    
    func getAllSights() -> [Sight] {
        return sights
    }
    
    func triggerRemoveSight(sight : Sight) {
        // force remove from store
        sqlh.removeSight(sight)
        sights.removeAtIndex(sights.indexOf(sight)!)
        
        // update subscribers
        for (_, subscriber) in subscribers {
            subscriber.removeSight(sight)
        }
    }
    func triggerAddSight(sight : Sight) {
        // force add to store
        sqlh.storeSight(sight)
        sights.append(sight)
        
        //update subscribers
        for (_, subscriber) in subscribers {
            subscriber.addSight(sight)
        }
        
        if hasShown == false {
            JLToastView.setDefaultValue(80, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
            JLToastView.setDefaultValue(UIColor(red:0.102, green:0.788, blue:0.341, alpha:1),
                forAttributeName: JLToastViewBackgroundColorAttributeName,
                userInterfaceIdiom: .Phone)
            JLToast.makeText("Er zijn nieuwe Sights toegevoegd in uw omgeving!", delay: 0, duration: 2).show()
            hasShown = true
        }
        
    }
    func triggerUpdateSight(oldSight: Sight, newSight: Sight) {
        // force update in store
        sqlh.updateSight(oldSight, newSight: newSight)
        
        let selected : Bool = isSelected(oldSight)
        if selected {
            markSightSelected(oldSight, selected: false)
        }
        sights.removeAtIndex(sights.indexOf(oldSight)!)
        sights.append(newSight)
        markSightSelected(newSight, selected: selected)
        
        // update subscribers
        for(_, subscriber) in subscribers {
            subscriber.updateSight(oldSight, newSight: newSight)
        }
    }
    
    func forceSynchronisation() {
        sightSyncer!.forceUpdating()
    }
    
    private func loadSights() {
        if let newSights : [Sight] = sqlh.getSights() {
            sights = newSights
        }
    }
    
    /**
     *
     * functions which handle the selectionstate of a sight
     *
     **/
     
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
    
    func hasSelectedSights() -> Bool {
        return !userChosen.isEmpty
    }
    
    func markSightAsVisited(sight : Sight) {
        markSightAsVisited(sight, visited: true)
    }
    
    func markSightAsVisited(sight : Sight, visited : Bool) {
        if visited && !visitedA.contains(sight) {
            visitedA.append(sight)
            storeVisited(sight.id)
        }
    }
    
    func isVisited(sight : Sight) -> Bool {
        return visitedA.contains(sight)
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
    
    func getSelectedCount() -> Int {
        return userChosen.count
    }
    
    func getSelected() -> [Sight] {
        return userChosen
    }
     
    
    /**
     *
     * functions which handle the position of a selected sight
     *
     **/
    
    func switchPosition(sightOne : Sight, sightTwo : Sight) {
        if isSelected(sightOne) && isSelected(sightTwo) {
            let posOne : Int = getSelectedIndex(sightOne)!
            let posTwo : Int = getSelectedIndex(sightTwo)!
            
            userChosen[posOne] = sightTwo
            userChosen[posTwo] = sightOne
        }
    }
    
    func getSelectedIndex(sight : Sight) -> Int? {
        return userChosen.indexOf(sight)
    }
    
    func storeVisited(id: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if let entry = NSEntityDescription.insertNewObjectForEntityForName("Visited", inManagedObjectContext: context) as? Visited {
            entry.id = id
            appDelegate.saveContext()
        }
    }
    
    func getAllVisited() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Visited");
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Visited]
            for vis in fetchResults! {
                if let i = sights.indexOf({$0.id == vis.id!}) {
                    if !visitedA.contains(sights[i]) {
                        visitedA.append(sights[i])
                        print(visitedA.first?.id)
                    }
                }
            }
        } catch let error as NSError {
            debugPrint(error)
        }
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

    var userChosen = [Sight]()
    var favorites = [Sight]()
    var visitedA = [Sight]()
    private var sights = [Sight]()
}