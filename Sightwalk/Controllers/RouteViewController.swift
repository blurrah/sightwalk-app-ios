//
//  RouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UIGestureRecognizerDelegate, RouteDirectionsViewControllerDelegate, RouteDetailDirectionsViewControllerDelegate {

    var mapView: RouteMapViewController?
    var directionsView: RouteDirectionsViewController?
    var detailView: RouteDetailDirectionsViewController?
    let chosenSights = SightStore.sharedInstance.userChosen
    
    
    private var sightShowController : SightDetailViewController?
    private var returnToStart : Bool = true
    
    
    private var activity : Activity?
    private var nextSight : Sight?
    
    var currentSight: Int = 0
    
    @IBAction func tapStopRoute(sender: AnyObject) {
        let alertView = UIAlertController(title: "Stoppen", message: "Weet u zeker dat u wilt stoppen?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "Stoppen", style: .Default, handler: { (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: {})
        }))
        
        alertView.addAction(UIAlertAction(title: "Annuleren", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Continue pushed")
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        let sb = UIStoryboard.init(name: "Route", bundle: nil)
        mapView = sb.instantiateViewControllerWithIdentifier("mapViewController") as? RouteMapViewController
        directionsView = sb.instantiateViewControllerWithIdentifier("directionsViewController") as? RouteDirectionsViewController
        detailView = sb.instantiateViewControllerWithIdentifier("detailViewController") as? RouteDetailDirectionsViewController
        
        // update activity
        if self.activity != nil {
            mapView!.setActivity(activity!)
            directionsView!.setActivity(activity!)
            detailView!.setActivity(activity!)
        }
        
        
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
        
        if activity != nil {
            directionsView!.setActivity(activity!)
            mapView!.setActivity(activity!)
        }
    }
    
    func setActivity(activity : Activity) {
        self.activity = activity
        directionsView?.setActivity(activity)
        mapView?.setActivity(activity)
        detailView?.setActivity(activity)
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
    
    func enteringSight(sight : Sight) {
        //detailView?.set
        performSegueWithIdentifier("showSightDetail", sender: self)
    }
    
    func leavingSight(leftSight : Sight, headingHome : Bool) {
        // do nothing (yet)
    }
    
    func setNextSight(nextSight : Sight) {
        directionsView!.setSight(nextSight)
        self.nextSight = nextSight
    }
    
    func setLocation(location : CLLocation) {
        // update map
        print("gps location manager")
        mapView!.center(location.coordinate)
    }
    
    // TODO: Add change sight logic

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSightDetail" {
            if let destination = segue.destinationViewController as? SightDetailViewController {
                if nextSight != nil {
                    destination.setSight(nextSight!)
                }
            }
        }
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }

}
