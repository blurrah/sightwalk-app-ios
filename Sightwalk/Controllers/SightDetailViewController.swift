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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentSight != nil {
            updateView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSight(sight : Sight) {
        currentSight = sight
    }
    
    private func updateView() {
        
        title = currentSight!.title
        lblDescription.text = currentSight!.text

        ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
            self.ivImage.image = UIImage(data: response)
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let id : String = segue.identifier {
//            if id == "unwindSightDetails" {
//                let rvc = segue.destinationViewController as! RouteViewController
//                rvc.leavingSight(currentSight!)
//            }
//        }
    }

}
