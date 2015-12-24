//
//  SightStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 10-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire

class SightStore : SightSyncInterface {
    class var sharedInstance: SightStore {
        struct Singleton {
            static let instance = SightStore()
        }
        return Singleton.instance
    }
    
    private var subscribers : [String : SightManager] = [:]
    private var sightSyncer : SightSyncer? = nil
    private let sqlh : SQLiteHelper
    
    
    init() {
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
    
    
    private var sights = [Sight]()
    var userChosen = [Sight]()
}