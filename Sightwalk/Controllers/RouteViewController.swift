//
//  RouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, RouteDirectionsViewControllerDelegate, RouteDetailDirectionsViewControllerDelegate {

    var mapView: RouteMapViewController?
    var directionsView: RouteDirectionsViewController?
    var detailView: RouteDetailDirectionsViewController?
    let chosenSights = SightStore.sharedInstance.userChosen
    private var currentIndex = 0
    let locationManager = CLLocationManager()
    private var atSight : Bool = false
    private var sightShowController : SightDetailViewController?
    private var startLocation : CLLocation?
    private var returnToStart : Bool = true
    private var walking : Bool = true
    private var returningHome : Bool = false
    
    var currentSight: Int = 0
    
    @IBAction func tapStopRoute(sender: AnyObject) {
        let alertView = UIAlertController(title: "Stoppen", message: "Weet u zeker dat u wilt stoppen?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "Stoppen", style: .Default, handler: { (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: {})
        }))
        
        alertView.addAction(UIAlertAction(title: "Doorgaan", style: .Default, handler: { (action: UIAlertAction!) in
            print("Continue pushed")
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        let sb = UIStoryboard.init(name: "Route", bundle: nil)
        mapView = sb.instantiateViewControllerWithIdentifier("mapViewController") as? RouteMapViewController
        directionsView = sb.instantiateViewControllerWithIdentifier("directionsViewController") as? RouteDirectionsViewController
        detailView = sb.instantiateViewControllerWithIdentifier("detailViewController") as? RouteDetailDirectionsViewController
        
        self.addChildViewController(mapView!)
        mapView!.didMoveToParentViewController(self)
        self.view.addSubview(mapView!.view)
        
        self.addChildViewController(directionsView!)
        directionsView!.didMoveToParentViewController(self)
        self.view.addSubview(directionsView!.view)
        
        self.addChildViewController(detailView!)
        detailView!.didMoveToParentViewController(self)
        self.view.addSubview(detailView!.view)
        detailView!.view.alpha = 0
        
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        mapView!.view.frame = CGRectMake(0, 0, width, height/1.66667)
        directionsView!.view.frame = CGRectMake(0, height/1.5, width, height)
        detailView!.view.frame = CGRectMake(0, height/1.5, width, height)
        
        directionsView!.delegate = self
        detailView!.delegate = self
    }
    
    func routeDetailDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?) {
        showDirectionsView()
    }
    
    func routeDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?) {
        showDetailView()
    }
    
    func routeDirectionsViewControllerSightDetailPressed(controller: UIViewController, info: AnyObject?) {
        self.performSegueWithIdentifier("showSightDetail", sender: nil)
    }
    
    func setStartPosition(position : CLLocation, returnHere : Bool) {
        startLocation = position
        returnToStart = returnHere
    }

    private func showDetailView() {
        let width : CGFloat = self.view.frame.size.width;
        let height : CGFloat = self.view.frame.size.height;
        let offset : CGFloat = 100
        UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
            self.mapView!.view.frame = CGRectMake(0, 0-offset, width, height);
            self.directionsView!.view.alpha = 0
            self.detailView!.view.frame = CGRectMake(0, height/1.6-offset, width, height/1.6-offset);
            self.detailView!.view.alpha = 1
            }, completion: nil )
    }
    
    private func showDirectionsView() {
        let width : CGFloat = self.view.frame.size.width;
        let height : CGFloat = self.view.frame.size.height;
        UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
            self.mapView!.view.frame = CGRectMake(0, 0, width, height/1.66667);
            self.detailView!.view.alpha = 0
            self.directionsView!.view.frame = CGRectMake(0, height/1.5, width, height);
            self.directionsView!.view.alpha = 1
            }, completion: nil )
    }
    
    
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
        var coordinate : CLLocationCoordinate2D
        var location : CLLocation
        if let location1: CLLocation! = manager.location {
            location = location1!
            coordinate = location1!.coordinate
        } else {
            return
        }
        
        // update map
        mapView!.center(coordinate)
        
        // apply tracking
        if let nextSight : Sight = getNextSight() {
            let distance : Double = nextSight.distanceTo(location)
            if distance < 50 {
                // within 50 meters distance
                
                if !atSight {
                    // trigger opening sight
                    enteringSight(nextSight)
                }
                
                atSight = true
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
    
    private func enteringSight(sight : Sight) {
        performSegueWithIdentifier("showSightDetail", sender: self)
        
        if (chosenSights.indexOf(sight)! + 1) >= chosenSights.count {
            // this is the last sight
            if !returnToStart && startLocation != nil {
                // stop walking
                walking = false
            } else {
                // go home
                returningHome = true
            }
        }
        print("entering")
    }
    
    private func leavingSight(sight : Sight) {
        if !returningHome {
            // there are more sights
            let nextSight : Sight = chosenSights[currentIndex + 1]
            directionsView!.setSight(nextSight)
        }
        print("leaving")
    }
    
    private func returnedHome() {
        // stop walking instantly
        walking = false
        print("stop!!! bitch")
    }
    
    private func getNextSight() -> Sight? {
        if currentIndex >= chosenSights.count {
            return nil
        }
        
        return chosenSights[currentIndex]
    }
    
    // TODO: Add change sight logic

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSightDetail" {
            if let destination = segue.destinationViewController as? SightDetailViewController {
                let nextSight : Sight? = getNextSight()
                if nextSight != nil {
                    destination.setSight(nextSight!)
                }
                sightShowController = destination
            }
        }
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }

}
