//
//  CreateRouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 27-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class CreateRouteViewController: UIViewController {

    @IBOutlet var startRouteButtonOutlet: StateDependantButton!
    
    @IBAction func tapPickSpotsTempButton(sender: AnyObject) {
        self.performSegueWithIdentifier("displayPickSpots", sender: sender)
    }

    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startRouteButtonOutlet.enableButton()
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
