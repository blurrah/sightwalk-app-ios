//
//  ActivityViewController.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 17/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Foundation
import SwiftyJSON

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    private var activities : [Activity]! = []
    private let activityStore : RouteStore = RouteStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(animated: Bool) {
        activities = RouteStore.sharedInstance.getAllActivities().sort({ $0.getDate() > $1.getDate() })
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        let row = indexPath.row
        
        cell.activityLabel.text = "De route '" + activities[row].name + "' is gestart om " + activities[row].dateTime
            
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            activityStore.removeActivity(activities[indexPath.row])
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Verwijderen"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let selected : Activity = activities[indexPath.row]
        
        // prompt user to confirm starting route
        let alert = UIAlertController(title: "Route starten", message: "Wilt u de route '" + selected.name + "' starten?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default, handler: { action in
            
            // start route
            if let vc = RouteNavigationController.startRoute(selected, returnAtStart: true) {
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                print("cant start route")
            }

        }))
        alert.addAction(UIAlertAction(title: "Nee", style: UIAlertActionStyle.Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

