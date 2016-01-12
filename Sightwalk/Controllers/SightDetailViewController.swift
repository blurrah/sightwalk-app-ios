//
//  SightDetailViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 07-01-16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class SightDetailViewController: UIViewController {
    
    let sightStore = SightStore.sharedInstance
    
    @IBOutlet var titleBar: UINavigationItem!
    @IBOutlet var sightImageView: UIImageView!
    @IBOutlet var sightNameLabel: UILabel!
    @IBOutlet var sightTextView: UITextView!
    @IBOutlet var addFavoriteButton: GenericViewButton!
    
    private var currentSight : Sight?

    
    @IBAction func addAsFavorite(sender: AnyObject) {
        sightStore.markSightAsFavorite(currentSight!, favorite: true)
        
        changeFavoriteButtonText()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentSight != nil {
            self.titleBar.title = currentSight!.title
            self.sightNameLabel.text = currentSight!.title
            self.sightTextView.text = currentSight!.text
            self.sightTextView.editable = false
            
            ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
                self.sightImageView.image = UIImage(data: response)
            })
            
            changeFavoriteButtonText()
        } else {
            print("current sight is nil, there might be something wrong")
        }
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
    
    func changeFavoriteButtonText() {
        if sightStore.isFavorite(currentSight!) {
            self.addFavoriteButton.titleLabel!.text = "Verwijder van favorieten"
        } else {
            self.addFavoriteButton.titleLabel!.text = "Voeg toe aan favorieten"
        }
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
