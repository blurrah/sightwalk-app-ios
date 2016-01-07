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
    
    let sights = SightStore.sharedInstance.userChosen

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

        // Do any additional setup after loading the view.
        
        let sightStore = SightStore.sharedInstance
        let totalDistance = RouteStore.sharedInstance.calculateTotalDistance()
        let (h, m, _) = RouteStore.sharedInstance.calculateTotalTime()
        
        self.sightTitleOutlet.text = sightStore.userChosen[0].title
        self.sightDescriptionOutlet.text = sightStore.userChosen[0].shortdesc
        self.timeOutlet.text = "\(h) uur, \(m) min"
        self.distanceOutlet.text = "\(totalDistance) km"
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
