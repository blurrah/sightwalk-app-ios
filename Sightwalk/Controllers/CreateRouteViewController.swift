//
//  CreateRouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 27-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class CreateRouteViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var startRouteButtonOutlet: StateDependantButton!
    @IBOutlet var pickItemButtonOutlet: PickItemButtonView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomTableViewConstraintOutlet: NSLayoutConstraint!
    @IBOutlet var totalsTextOutlet: UILabel!
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sqlh = SQLiteHelper.sharedInstance
        
        if SightStore.sharedInstance.sights.count == 0 {
            let sights = sqlh.getSights()
            SightStore.sharedInstance.sights = sights!
        }

        // Do any additional setup after loading the view.
        startRouteButtonOutlet.enableButton()
        
        self.view.userInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        
        let touchGesture = UITapGestureRecognizer(target: self, action: Selector("handlePickSpotsTap:"))
        touchGesture.delegate = self
        self.pickItemButtonOutlet.addGestureRecognizer(touchGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressSights:"))
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongPressSights(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        
        let locationInView = longPress.locationInView(tableView)
        
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot = snapshotOfCell(cell)
                
                var center = cell.center
                
                My.cellSnapshot!.center = center
                
                My.cellSnapshot!.alpha = 0.0
                
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.hidden = true
                    }
                })
            }
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                var chosenSights = SightStore.sharedInstance.sights.filter() { $0.chosen == true }
                swap(&chosenSights[indexPath!.row], &chosenSights[Path.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePickSpotsTap(sender: UITapGestureRecognizer? = nil) {
        self.performSegueWithIdentifier("displayPickSpots", sender: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sights = SightStore.sharedInstance.sights
        let chosen = sights.filter() { $0.chosen == true }

        return chosen.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        let sights = SightStore.sharedInstance.sights.filter() { $0.chosen == true }
        
        let row = indexPath.row
        cell.contentView.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.95, alpha:1)
        cell.textLabel?.textColor = UIColor(red:0.12, green:0.81, blue:0.43, alpha:1)
        cell.textLabel?.text = sights[row].name
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        
        let sights = SightStore.sharedInstance.sights
        let chosen = sights.filter() { $0.chosen == true }
        
        self.bottomTableViewConstraintOutlet.constant = CGFloat(chosen.count) * 44
        
        if chosen.count > 0 {
            GoogleDirectionsAPIHelper.sharedInstance.getDirections("Breda", sights: chosen, onCompletion: { results in
                let distance = results["routes"][0]["legs"][0]["distance"]["text"].string
                
                self.totalsTextOutlet.text = "Totaal \(chosen.count) sights / \(distance!) afstand"
            })
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }

}
