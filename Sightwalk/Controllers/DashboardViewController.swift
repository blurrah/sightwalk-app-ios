//
//  DashboardViewController.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 16/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    @IBOutlet weak var activityViewOutlet: UIView!
    @IBOutlet weak var statisticViewOutlet: UIView!
    @IBOutlet weak var favoriteViewOutlet: UIView!
    @IBOutlet weak var totalViewOutlet: UIView!

    
    @IBAction func indexChangedAction(sender: UISegmentedControl) {
        switch segmentedControlOutlet.selectedSegmentIndex {
        case 0:
            UIView.animateWithDuration(0.5, animations: {
                self.activityViewOutlet.alpha = 1
                self.statisticViewOutlet.alpha = 0
                self.favoriteViewOutlet.alpha = 0
            })
        case 1:
            UIView.animateWithDuration(0.5, animations: {
                self.activityViewOutlet.alpha = 0
                self.statisticViewOutlet.alpha = 1
                self.favoriteViewOutlet.alpha = 0
            })
        case 2:
            UIView.animateWithDuration(0.5, animations: {
                self.activityViewOutlet.alpha = 0
                self.statisticViewOutlet.alpha = 0
                self.favoriteViewOutlet.alpha = 1
            })
        default:
            break;
        }
    }
    
    @IBAction func tapCreateRouteAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "CreateRoute", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as UIViewController!
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        swipeRight.direction = .Right
        self.view.addGestureRecognizer(swipeRight)
        
        activityViewOutlet.alpha = 1
        statisticViewOutlet.alpha = 0
        favoriteViewOutlet.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        segmentedControlOutlet.selectedSegmentIndex = (segmentedControlOutlet.selectedSegmentIndex + 1) % segmentedControlOutlet.numberOfSegments
        indexChangedAction(segmentedControlOutlet)
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        segmentedControlOutlet.selectedSegmentIndex = (segmentedControlOutlet.selectedSegmentIndex - 1) % segmentedControlOutlet.numberOfSegments
        if(segmentedControlOutlet.selectedSegmentIndex == -1){
            segmentedControlOutlet.selectedSegmentIndex = segmentedControlOutlet.numberOfSegments-1
        }
        indexChangedAction(segmentedControlOutlet)
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
