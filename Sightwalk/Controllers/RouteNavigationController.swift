//
//  RouteNavigationController.swift
//  Sightwalk
//
//  Created by frank kuipers on 1/11/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class RouteNavigationController: UINavigationController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}
