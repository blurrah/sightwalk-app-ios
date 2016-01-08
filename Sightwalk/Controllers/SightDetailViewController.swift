//
//  SightDetailViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 07-01-16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class SightDetailViewController: UIViewController {
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        performSegueWithIdentifier("unwindSightDetails", sender: self)
    }
    
    @IBOutlet var ivImage: UIImageView!
    @IBOutlet var lblDescription: UILabel!
    
    private var currentSight : Sight?
    @IBOutlet var sightTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentSight!.title
        
        self.sightTextLabel.text = currentSight!.text
        
        ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
            self.ivImage.image = UIImage(data: response)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSight(sight : Sight) {
        currentSight = sight
    }
    
    func triggerLeaveSight() {
        print("leaving sight")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let id : String = segue.identifier {
//            if id == "unwindSightDetails" {
//                let rvc = segue.destinationViewController as! RouteViewController
//                rvc.leavingSight(currentSight!)
//            }
//        }
    }
*/

}