//
//  RouteDetailDirectionsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 17-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

protocol RouteDetailDirectionsViewControllerDelegate {
    func routeDetailDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?)
}

class RouteDetailDirectionsViewController: UIViewController {
    
    var delegate: RouteDetailDirectionsViewControllerDelegate?
    
    let chosenSights = SightStore.sharedInstance.userChosen

    @IBAction func tapSightsButton(sender: AnyObject) {
        delegate!.routeDetailDirectionsViewControllerButtonPressed(self, info: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var spacer: CGFloat = 50
        for sight in chosenSights {
            let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
            label.textColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
            label.center = CGPointMake(160, 50 + spacer)
            label.text = sight.title
            self.view.addSubview(label)
            spacer = spacer + 50
        }
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
