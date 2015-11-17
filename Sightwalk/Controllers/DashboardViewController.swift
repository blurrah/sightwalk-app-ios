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
            activityViewOutlet.hidden = false;
            statisticViewOutlet.hidden = true;
            favoriteViewOutlet.hidden = true;
        case 1:
            activityViewOutlet.hidden = true;
            statisticViewOutlet.hidden = false;
            favoriteViewOutlet.hidden = true;
        case 2:
            activityViewOutlet.hidden = true;
            statisticViewOutlet.hidden = true;
            favoriteViewOutlet.hidden = false;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        swipeRight.direction = .Right
        self.view.addGestureRecognizer(swipeRight)
        
        activityViewOutlet.hidden = false;
        statisticViewOutlet.hidden = true;
        favoriteViewOutlet.hidden = true;

        // Do any additional setup after loading the view.
    }
    
    //TODO: Eventueel animaties toevoegen? Fade in/out is mogelijk, schuif animatie wordt lastig aangezien de views worden gehide/showt en er geeen gebruik wordt gemaakt van een segue.
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
