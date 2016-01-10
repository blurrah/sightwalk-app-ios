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
        RouteStore.sharedInstance.getAllActivities()
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RouteStore.sharedInstance.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        let row = indexPath.row
        let activities = RouteStore.sharedInstance.activities
        
        cell.activityLabel.text = "De route '" + activities[row].name + "' is gestart om " + activities[row].dateTime
        
        print(activities[row].dateTime)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            RouteStore.sharedInstance.removeActivity(Int(RouteStore.sharedInstance.activities[indexPath.row].id!))
            RouteStore.sharedInstance.activities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Verwijderen"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let activities = RouteStore.sharedInstance.activities

        let alert = UIAlertController(title: "Route starten", message: "Wilt u de route '" + activities[row].name + "' starten?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default, handler: { action in
            RouteStore.sharedInstance.apiResponse = JSON.parse(activities[row].jsonResponse)
            
            let userChosenId = activities[row].userChosen.characters.split{$0 == "-"}.map(String.init)
            SightStore.sharedInstance.getUserChosenForActivity(userChosenId)
            
            RouteStore.sharedInstance.storeActivity(activities.count)
            
            let storyboard = UIStoryboard(name: "Route", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as UIViewController!
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Nee", style: UIAlertActionStyle.Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

