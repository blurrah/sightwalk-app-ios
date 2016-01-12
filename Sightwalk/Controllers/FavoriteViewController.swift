//
//  FavoriteViewController.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 17/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Foundation

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let imageDownloader = ImageDownloadHelper()
    
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
        SightStore.sharedInstance.getAllFavorites()
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SightStore.sharedInstance.favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        let row = indexPath.row
        let sights = SightStore.sharedInstance.favorites
        
        cell.sightTitleLabel.text = sights[row].title
        cell.sightDescriptionLabel.text = sights[row].shortdesc
        
        ImageDownloadHelper.downloadImage(sights[row].imgurl, onCompletion: { response in
            cell.favoriteImageView.image = UIImage(data: response)
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            SightStore.sharedInstance.removeFavorite(SightStore.sharedInstance.favorites[indexPath.row].id)
            SightStore.sharedInstance.favorites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Verwijderen"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFavoriteDetail" {
            if let destination = segue.destinationViewController as? SightDetailViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let selected = SightStore.sharedInstance.favorites[indexPath.row]
                    destination.setSight(selected)
                }
            }
        }
    }
}

