//
//  RouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UIGestureRecognizerDelegate, RouteDirectionsViewControllerDelegate {

    var mapView: RouteMapViewController?
    var directionsView: RouteDirectionsViewController?
    
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
    
    var state = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sb = UIStoryboard.init(name: "Route", bundle: nil)
        mapView = sb.instantiateViewControllerWithIdentifier("mapViewController") as? RouteMapViewController
        directionsView = sb.instantiateViewControllerWithIdentifier("directionsViewController") as? RouteDirectionsViewController
        
        self.addChildViewController(mapView!)
        mapView!.didMoveToParentViewController(self)
        self.view.addSubview(mapView!.view)
        
        self.addChildViewController(directionsView!)
        directionsView!.didMoveToParentViewController(self)
        self.view.addSubview(directionsView!.view)
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        mapView!.view.frame = CGRectMake(0, 0, width, height/1.66667)
        directionsView!.view.frame = CGRectMake(0, height/1.5, width, height)
        
        directionsView!.delegate = self
    }
    
    func routeDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?) {
        let width : CGFloat = self.view.frame.size.width;
        let height : CGFloat = self.view.frame.size.height;
        
        let offset : CGFloat = 100
        
        if !state {
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.mapView!.view.frame = CGRectMake(0, 0-offset, width, height);
                self.directionsView!.view.frame = CGRectMake(0, height/1.5-offset, width, height);
                }, completion: nil )
        } else {
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.mapView!.view.frame = CGRectMake(0, 0, width, height/1.66667);
                self.directionsView!.view.frame = CGRectMake(0, height/1.5, width, height);
                }, completion: nil )
        }
        
        state = !state
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
