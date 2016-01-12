//
//  RouteNavigationController.swift
//  Sightwalk
//
//  Created by frank kuipers on 1/11/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class RouteNavigationController: UINavigationController, CLLocationManagerDelegate {

    static func startRoute(activity : Activity, returnAtStart : Bool) -> RouteNavigationController? {
        if !activity.readyForWalking() {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Route", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! RouteNavigationController!
        vc.initialize(activity, returnAtStart: returnAtStart)
        
        return vc
    }
    
    private var routeViewController : RouteViewController?
    private var activity : Activity?
    let locationManager = CLLocationManager()
    private var walking : Bool = true
    private var atSight : Bool = false
    private var currentIndex = 0
    private var returningHome : Bool = false
    private var startLocation : CLLocation?
    private var returnToStart : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        routeViewController = viewControllers.first as! RouteViewController!
        if activity != nil {
            routeViewController?.setActivity(activity!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(activity : Activity, returnAtStart : Bool) {
        // store route
        self.activity = RouteStore.sharedInstance.newActivity()
        activity.duplicateInto(self.activity!)
        self.activity!.setDate()
        RouteStore.sharedInstance.saveContext()
        
        //
        routeViewController?.setActivity(self.activity!)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // gps methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        if !walking {
            manager.stopUpdatingLocation()
            return
        }
        
        // grab data
        var location : CLLocation
        if let location1: CLLocation! = manager.location {
            location = location1!
        } else {
            return
        }
        
        // set start location??
        if startLocation == nil {
            startLocation = location
        }
        
        routeViewController?.setLocation(location)
        
        // apply tracking
        if let nextSight : Sight = getNextSight() {
            let distance : Double = nextSight.distanceTo(location)
            if distance < 50 {
                // within 50 meters distance
                
                if !atSight {
                    // trigger opening sight
                    if let nextSight = getNextSight() {
                        enteringSight(nextSight)
                        atSight = true
                    }
                }
            }
            
            if distance >= 50 {
                if atSight {
                    // trigger opening directions
                    leavingSight(nextSight)
                    currentIndex++
                }
                
                atSight = false
            }
        } else {
            // not heading to a sight, heading home?
            if returningHome && startLocation != nil {
                if Double(startLocation!.distanceFromLocation(manager.location!)) <= 50 {
                    returnedHome()
                }
            }
        }
    }
    
    private func getNextSight() -> Sight? {
        if currentIndex >= activity!.getSights().count {
            return nil
        }
        
        return activity!.getSights()[currentIndex]
    }
    
    func enteringSight(sight : Sight) {
        let sights : [Sight] = activity!.getSights()
        if (sights.indexOf(sight)! + 1) >= sights.count {
            // this is the last sight
            if !returnToStart && startLocation != nil {
                // stop walking
                walking = false
            } else {
                // go home
                returningHome = true
            }
        }
        
        routeViewController?.enteringSight(sight)
        print("entering")
    }
    
    func leavingSight(sight : Sight) {
        
        routeViewController?.leavingSight(sight, headingHome: returningHome)
        
        if !returningHome {
            // there are more sights
            let nextSight : Sight = activity!.getSights()[currentIndex + 1]
            routeViewController!.setNextSight(nextSight)
        }
        print("leaving")
    }
    
    func returnedHome() {
        // okay, do nothing
    }
}
