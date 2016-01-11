//
//  RouteDirectionsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

protocol RouteDirectionsViewControllerDelegate {
    func routeDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?)
    func routeDirectionsViewControllerSightDetailPressed(controller: UIViewController, info: AnyObject?)
}

class RouteDirectionsViewController: UIViewController {
    
    var delegate: RouteDirectionsViewControllerDelegate?
    
    private var activity : Activity?
    private var sight : Sight?

    @IBOutlet var sightTitleOutlet: UILabel!
    @IBOutlet var sightDescriptionOutlet: UILabel!
    @IBOutlet var timeOutlet: UILabel!
    @IBOutlet var distanceOutlet: UILabel!
    
    @IBAction func tapButton(sender: AnyObject) {
        delegate!.routeDirectionsViewControllerButtonPressed(self, info: nil)
    }
    
    @IBAction func tapSightDetail(sender: AnyObject) {
        delegate!.routeDirectionsViewControllerSightDetailPressed(self, info: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sight != nil {
            setSight(sight!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setActivity(activity : Activity) {
        self.activity = activity
        setSight(activity.getSights().first!)
    }
    
    func setSight(sight : Sight) {
        self.sight = sight
        
        let totalDistance = activity!.getTotalDistance()
        let (h, m, _) = activity!.getTotalTime()
        
        self.sightTitleOutlet?.text = sight.title
        self.sightDescriptionOutlet?.text = sight.shortdesc
        self.timeOutlet?.text = "\(h) uur, \(m) min"
        self.distanceOutlet?.text = "\(totalDistance) km"
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
