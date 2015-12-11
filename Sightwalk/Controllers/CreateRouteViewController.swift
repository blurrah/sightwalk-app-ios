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
        
        var locationInView = longPress.locationInView(tableView)
        
        var indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        print(locationInView)
        print(indexPath)
        
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
        cell.textLabel?.text = sights[row].name
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        
        let sights = SightStore.sharedInstance.sights
        let chosen = sights.filter() { $0.chosen == true }
        
        self.bottomTableViewConstraintOutlet.constant = CGFloat(chosen.count) * 44
        
        self.totalsTextOutlet.text = "Totaal \(chosen.count) sights / 0 km afstand"
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
