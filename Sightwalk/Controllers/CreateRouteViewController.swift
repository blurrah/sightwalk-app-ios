//
//  CreateRouteViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 27-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

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
    
    var availableHeight : CGFloat = 0.0
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func tapStartButton(sender: AnyObject) {
        print(currentGeoPosition)
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
        let storyboard = UIStoryboard(name: "Route", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController() as UIViewController!
        //presentViewController(vc, animated: true, completion: nil)
        
//        let vc = storyboard.instantiateViewControllerWithIdentifier("RouteView") as! RouteViewController
//        
//        if currentGeoPosition !== nil {
//            vc.setStartPosition(currentGeoPosition!, returnHere: endPointSegmentedOutlet.selectedSegmentIndex == 0)
//        }
        
        
        presentViewController(vc, animated: true, completion: nil)
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
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        availableHeight = screenSize.height * CGFloat(0.25)
        
        sightStore.subscribe(self, slot: "createrouteview")
        
        self.locationManager.requestAlwaysAuthorization()
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
        
        if (currentGeoPosition == nil) {
            startPointSwitchOutlet.on = true
            startPointSwitchOutlet.enabled = false
            let alert = UIAlertController(title: "Geen locatie gevonden", message: "We hebben uw locatie niet kunnen vaststellen. De eerste gekozen Sight wordt ingesteld als startlocatie", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func addSight(sight : Sight) {
        // not interesting, sight is not selected
    }
    
    func updateSight(oldSight: Sight, newSight: Sight) {
        // only interesting if sight is selected
        if sightStore.isSelected(newSight) {
            // update the column
        }
    }
    
    func removeSight(sight: Sight) {
        // only interesting if sight is selected
        if sightStore.isSelected(sight) {
            // remove sight from table
            sightStore.markSightSelected(sight, selected: false)
            
            if (CGFloat(sightStore.getSelectedCount()) < CGFloat((availableHeight / 44))) {
                self.bottomTableViewConstraintOutlet.constant = CGFloat(sightStore.getSelectedCount()) * 44
                tableView.scrollEnabled = false
            } else {
                self.bottomTableViewConstraintOutlet.constant = CGFloat(availableHeight)
                tableView.scrollEnabled = true
            }
            
            if (sightStore.getSelectedCount() == 0) {
                
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
                sightStore.switchPosition(sightStore.userChosen[indexPath!.row], sightTwo: sightStore.userChosen[Path.initialIndexPath!.row])
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
        return sightStore.getSelectedCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")

        let row = indexPath.row
        cell.contentView.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.95, alpha:1)
        cell.textLabel?.textColor = UIColor(red:0.12, green:0.81, blue:0.43, alpha:1)
        cell.textLabel?.text = sightStore.userChosen[row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            removeSight(sightStore.userChosen[indexPath.item])
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Verwijderen"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
        if (CGFloat(sightStore.getSelectedCount()) < CGFloat((availableHeight / 44))) {
            self.bottomTableViewConstraintOutlet.constant = CGFloat(sightStore.getSelectedCount()) * 44
            tableView.scrollEnabled = false
        } else {
            self.bottomTableViewConstraintOutlet.constant = CGFloat(availableHeight)
            tableView.scrollEnabled = true
        }
        
        updateSegmentedControl()
        if sightStore.hasSelectedSights() {
            updateDistance()
        }
    }
    
    func updateDistance() {
        if sightStore.hasSelectedSights() {
            GoogleDirectionsAPIHelper.sharedInstance.getDirections(getStartPoint(), destination: getEndPoint(), sights: sightStore.userChosen, onCompletion: { results in
                let totalDistance = RouteStore.sharedInstance.calculateTotalDistance()
                let (h, m, _) = RouteStore.sharedInstance.calculateTotalTime()
                
                RouteStore.sharedInstance.setPolylines()

                RouteStore.sharedInstance.chosenRoute = results["routes"][0]["overview_polyline"]["points"].string
                
                self.totalsTextOutlet.text = "Totaal \(self.sightStore.getSelectedCount()) sights / \(totalDistance) km afstand\r \(h) uur, \(m) min"
                if (self.startPointSwitchOutlet.on && self.sightStore.userChosen.count >= 2) || (self.startPointSwitchOutlet.on == false) {
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
    }

    func getStartPoint() -> String {
        if let pos : CLLocation = currentGeoPosition {
            if startPointSwitchOutlet.on == false {
                let lon = String(pos.coordinate.longitude)
                let lat = String(pos.coordinate.latitude)
            
                return "\(lat), \(lon)"
            }
        }
        let location = sightStore.userChosen.first!.location
        let lon = String(location.longitude)
        let lat = String(location.latitude)
            
        return "\(lat), \(lon)"
    }
    
    func getEndPoint() -> String {
        if endPointSegmentedOutlet.selectedSegmentIndex == 0 {
            // end on last sight
            let location = sightStore.userChosen.last!.location
            let lon = String(location.longitude)
            let lat = String(location.latitude)
            
            return "\(lat), \(lon)"
        }
        
        // end on startposition
        return getStartPoint()
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
        let hasSights : Bool = sightStore.hasSelectedSights()
        
        // enable or disable segmentedcontrol
        endPointSegmentedOutlet.selectedSegmentIndex = hasSights ? 1 : 0
        endPointSegmentedOutlet.enabled = hasSights
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
