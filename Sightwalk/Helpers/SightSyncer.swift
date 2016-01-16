//
//  SightSyncer.swift
//  Sightwalk
//
//  Created by frank kuipers on 12/17/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SightSyncer: NSObject, CLLocationManagerDelegate {

    private var client : SightSyncInterface
    
    private let locationManager = CLLocationManager()
    
    private var lastSyncTime : NSDate?
    private var lastSyncPosition : CLLocation?
    
    private let deltaSyncTime : Int = 600 // ten minutes
    private let deltaSyncPosition : Int = 10000 // one kilometer
    private let syncDistance : Int = 100 // ten kilometers
    private var force : Bool = false
    
    init(client : SightSyncInterface) {
        self.client = client
        
        super.init()
        setupGpsPolling()
    }
    
    private func setupGpsPolling() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func forceUpdating() {
        force = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.first!
        let now = NSDate()

        if lastSyncTime != nil && !force {
            if Int(location.distanceFromLocation(lastSyncPosition!)) < deltaSyncPosition && Int(lastSyncTime!.timeIntervalSinceDate(now)) < deltaSyncTime {
                return
            }
        }
        
        lastSyncTime = now
        lastSyncPosition = location
        
        getSightsFromServer(location.coordinate)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("nou nee")
    }
    
    private func getSightsFromServer(coordinates: CLLocationCoordinate2D) {
        getSightsFromServer(coordinates.latitude.description, longitude: coordinates.longitude.description)
    }

    private func getSightsFromServer(latitude : String, longitude : String) {
        let geoPath : String = latitude + "/" + longitude + "/" + String(self.syncDistance)
        let path : String = ServerConstants.Sight.getInRange + "/" + geoPath
        
        UserAPIHelper.sharedInstance.getAuthenticatedCall(path, method: .GET, success: { json in
            var sights = [Int : Sight]()
            for node in json["sights"].arrayValue {
                sights[node["id"].intValue] = (Sight(data: node))
            }
            
            self.sync(sights)
        }, failure: { error in
            print("Could not read sights from server")
            print(error)
        })
    }
    
    private func sync(var sights : [Int : Sight]) {
        let oldSights : [Sight] = client.getAllSights()
        
        // convert array to dictionary
        for sight : Sight in oldSights {
            if sight.isFurtherThan(lastSyncPosition!, distance: syncDistance) {
                continue
            }
            
            if sights[sight.id] == nil {
                // remove sight
                client.triggerRemoveSight(sight)
                continue
            }
            
            if !sights[sight.id]!.dataEquals(sight) {
                // update sight
                client.triggerUpdateSight(sight, newSight: sights[sight.id]!)
            }
            
            sights.removeValueForKey(sight.id)
        }
        
        for (_, sight) in sights {
            // add sight
            client.triggerAddSight(sight)
        }
    }

}

protocol SightSyncInterface {
    func getAllSights() -> [Sight]
    func triggerRemoveSight(sight : Sight)
    func triggerAddSight(sight : Sight)
    func triggerUpdateSight(oldSight : Sight, newSight : Sight)
}
