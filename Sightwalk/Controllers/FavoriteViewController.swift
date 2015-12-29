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

class FavoriteViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var tableData = [Sight]();
    let imageDownloader = ImageDownloadHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableData = SightStore.sharedInstance.favorites
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableData = SightStore.sharedInstance.favorites
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        let row = indexPath.row
        
        cell.sightTitleLabel.text = tableData[row].title
        cell.sightDescriptionLabel.text = tableData[row].shortdesc
        
        imageDownloader.downloadImage(tableData[row].imgurl, onCompletion: { response in
            cell.imageView!.image = UIImage(data: response)
        })
        
        return cell
    }
}

