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
    
    func triggerRemoveSight(sight : Sight) {
        print("trigger remove")
    }
    func triggerAddSight(sight : Sight) {
        print("trigger add")
    }
    
    var sights = [Sight]()
    var userChosen = [Sight]()
    var endPoint = String()
    var origin = String()
}