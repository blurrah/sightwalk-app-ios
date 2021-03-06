//
//  CreateRouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 27-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import JLToast

class CreateRouteViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, SightManager {
    
    let locationManager = CLLocationManager()
    private var currentGeoPosition : CLLocation?
    private let sightStore : SightStore = SightStore.sharedInstance
    
    @IBOutlet var endPointSegmentedOutlet: UISegmentedControl!
    @IBOutlet var startRouteButtonOutlet: StateDependantButton!
    @IBOutlet var pickItemButtonOutlet: PickItemButtonView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomTableViewConstraintOutlet: NSLayoutConstraint!
    @IBOutlet var totalsTextOutlet: UILabel!
    @IBOutlet var startPointSwitchOutlet: UISwitch!
    
    private var gpsEnabled : Bool = false
    private var currentActivity : Activity = RouteStore.sharedInstance.newDummyActivity()
    
    var availableHeight : CGFloat = 0.0
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func tapStartButton(sender: AnyObject) {
        if (ReachabilityHelper.isConnectedToNetwork() == false) {
            JLToastView.setDefaultValue(UIColor.redColor(), forAttributeName:JLToastViewBackgroundColorAttributeName, userInterfaceIdiom: .Phone)
            JLToastView.setDefaultValue(80, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
            return
        }
        if (currentGeoPosition == nil) {
            let alert = UIAlertController(title: "Geen locatie gevonden", message: "We hebben uw locatie niet kunnen vaststellen. De eerste Sight is ingesteld als startpunt", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Doorgaan", style: UIAlertActionStyle.Default, handler: { action in
                self.launchRouteLoop()
            }))
            alert.addAction(UIAlertAction(title: "Annuleren", style: UIAlertActionStyle.Cancel, handler: { action in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            launchRouteLoop()
        }
    }
    
    @IBAction func startPointSwitchSwitched(sender: AnyObject) {
        updateDistance()
    }
    private func launchRouteLoop() {
        let alert : UIAlertController = UIAlertController(title: "Naam kiezen", message: "Vul hieronder een naam in voor de route.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Naam"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  { action in
            let textField = alert.textFields![0] as UITextField
            if textField.text!.isEmpty == false {
                self.currentActivity.name = textField.text!
                
                // launch
                let vc = RouteNavigationController.startRoute(self.currentActivity, returnAtStart: true)
                if vc != nil {
                    self.presentViewController(vc!, animated: true, completion: nil)
                    self.currentActivity = RouteStore.sharedInstance.newDummyActivity()
                } else {
                    print("cant start route")
                }
                
            } else {
                JLToast.makeText("U dient een naam in te voeren voor de route.", delay: 0, duration: 2).show()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Annuleer", style: UIAlertActionStyle.Cancel, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func endPointSegmentedAction(sender: AnyObject) {
        switch endPointSegmentedOutlet.selectedSegmentIndex {
        case 0:
            updateDistance()
        case 1:
            updateDistance()
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sightStore.getAllVisited()

        JLToastView.setDefaultValue(UIColor.redColor(), forAttributeName:JLToastViewBackgroundColorAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(80, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        availableHeight = screenSize.height * CGFloat(0.25)
        
        sightStore.subscribe(self, slot: "createrouteview")
        
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
        startRouteButtonOutlet.disableButton()
        updateSegmentedControl()

        
        self.view.userInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        
        let touchGesture = UITapGestureRecognizer(target: self, action: Selector("handlePickSpotsTap:"))
        touchGesture.delegate = self
        self.pickItemButtonOutlet.addGestureRecognizer(touchGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressSights:"))
        self.tableView.addGestureRecognizer(longPressGesture)
        
        }
    
    func addSight(sight : Sight) {
        // not interesting, sight is not selected
    }
    
    func updateSight(oldSight: Sight, newSight: Sight) {
        // not interesting
        
        let selected : Bool = currentActivity.isSelected(oldSight)
        if selected {
            currentActivity.markSightSelected(oldSight, selected: false)
        }
        currentActivity.markSightSelected(newSight, selected: selected)
    }
    
    func removeSight(sight: Sight) {
        // only interesting if sight is selected
        if currentActivity.isSelected(sight) {
            // remove sight from table
            currentActivity.markSightSelected(sight, selected: false)
            
            if (CGFloat(currentActivity.getSelectedCount()) < CGFloat((availableHeight / 44))) {
                self.bottomTableViewConstraintOutlet.constant = CGFloat(currentActivity.getSelectedCount()) * 44
                tableView.scrollEnabled = false
            } else {
                self.bottomTableViewConstraintOutlet.constant = CGFloat(availableHeight)
                tableView.scrollEnabled = true
            }
            
            if (currentActivity.getSelectedCount() == 0) {
                
            }
            
            tableView.reloadData()
            updateDistance()
        }
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
                let sights = currentActivity.getSights()
                currentActivity.switchPosition(sights[indexPath!.row], sightTwo: sights[Path.initialIndexPath!.row])
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
                        self.updateDistance()
                    }
            })
        }
    }

    
    
    func handlePickSpotsTap(sender: UITapGestureRecognizer? = nil) {
        self.performSegueWithIdentifier("displayPickSpots", sender: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentActivity.getSelectedCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")

        let row = indexPath.row
        cell.contentView.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.95, alpha:1)
        cell.textLabel?.textColor = UIColor(red:0.12, green:0.81, blue:0.43, alpha:1)
        cell.textLabel?.text = currentActivity.getSights()[row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            removeSight(currentActivity.getSights()[indexPath.item])
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Verwijderen"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        updateDistance()
        
        if (CGFloat(currentActivity.getSelectedCount()) < CGFloat((availableHeight / 44))) {
            self.bottomTableViewConstraintOutlet.constant = CGFloat(currentActivity.getSelectedCount()) * 44
            tableView.scrollEnabled = false
        } else {
            self.bottomTableViewConstraintOutlet.constant = CGFloat(availableHeight)
            tableView.scrollEnabled = true
        }
        
        updateSegmentedControl()
        if currentActivity.hasSelectedSights() {
            updateDistance()
        }
    }
    
    func updateDistance() {
        if ReachabilityHelper.isConnectedToNetwork() == true {
            if currentActivity.hasSelectedSights() {
                GoogleDirectionsAPIHelper.sharedInstance.getDirections(getStartPoint(), destination: getEndPoint(), sights: currentActivity.getSights(), onCompletion: { results in
                    self.currentActivity.setRouteInfo(results)
                    let totalDistance = self.currentActivity.getTotalDistance()
                    let (h, m, _) = self.currentActivity.getTotalTime()

                    self.totalsTextOutlet.text = "Totaal \(self.currentActivity.getSelectedCount()) sights / \(totalDistance) km afstand\r \(h) uur, \(m) min"
                    if (self.startPointSwitchOutlet.on && self.currentActivity.getSelectedCount() >= 2) || (self.startPointSwitchOutlet.on == false) {
                        self.startRouteButtonOutlet.enableButton()
                    } else {
                        self.startRouteButtonOutlet.disableButton()
                    }
                })
            } else {
                self.startRouteButtonOutlet.disableButton()
                self.updateSegmentedControl()
                self.totalsTextOutlet.text = "Totaal 0 sights / 0 km afstand"
            }
        } else {
            self.totalsTextOutlet.text = "Totaal 0 sights / 0 km afstand"
            JLToast.makeText("U heeft geen verbinding met internet. Controleer uw verbinding en probeer het opnieuw.", delay: 0, duration: 2).show()
        }
    }

    func getStartPoint() -> String {
        if let pos : CLLocation = currentGeoPosition {
            if startPointSwitchOutlet.on == false {
                let lon = String(pos.coordinate.longitude)
                let lat = String(pos.coordinate.latitude)
            
                return "\(lat), \(lon)"
            }
        }
        
        if let firstSight = currentActivity.getSights().first {
            let location = firstSight.location
            let lon = String(location.longitude)
            let lat = String(location.latitude)
            
            return "\(lat), \(lon)"
        }
        
        return "(0), (0)"
    }
    
    func getEndPoint() -> String {
        if !returnAtStartPoint() {
            // end on last sight
            let location = currentActivity.getSights().last!.location
            let lon = String(location.longitude)
            let lat = String(location.latitude)
            
            return "\(lat), \(lon)"
        }
        
        // end on startposition
        return getStartPoint()
    }
    
    func returnAtStartPoint() -> Bool {
        return endPointSegmentedOutlet.selectedSegmentIndex != 0
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentGeoPosition = manager.location!
        startPointSwitchOutlet.enabled = true
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            
            gpsEnabled = true
        }
    }
    
    private func updateSegmentedControl() {
        let hasSights : Bool = currentActivity.hasSelectedSights()
        
        // enable or disable segmentedcontrol
        endPointSegmentedOutlet.selectedSegmentIndex = hasSights ? 1 : 0
        endPointSegmentedOutlet.enabled = hasSights
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayPickSpots" {
            if let controller = segue.destinationViewController as? PickSpotsViewController {
                controller.setActivity(currentActivity)
            }
        }
    }
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
