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
    let colorGreen : UIColor = UIColor(red:0.102, green:0.788, blue:0.341, alpha:1)
    
    @IBAction func addAsFavorite(sender: AnyObject) {
        let newFavorite : Bool = !sightStore.isFavorite(currentSight!)
        sightStore.markSightAsFavorite(currentSight!, favorite: newFavorite)
        
        if newFavorite {
            self.addFavoriteButton.backgroundColor = UIColor.redColor()
            self.addFavoriteButton.setTitle("Verwijder van favorieten", forState: .Normal)
        } else {
            self.addFavoriteButton.backgroundColor =  colorGreen
            self.addFavoriteButton.setTitle("Voeg toe aan favorieten", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentSight != nil {
            self.titleBar.title = currentSight!.title
            self.sightNameLabel.text = currentSight!.title
            self.sightTextView.text = currentSight!.text
            self.sightTextView.editable = false
            
            if currentSight!.imgurl.characters.count > 1 {
                ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
                    self.sightImageView.image = UIImage(data: response)
                })
            } else {
                self.sightImageView.image = UIImage()
            }
            
            if (sightStore.isFavorite(currentSight!)) {
                self.addFavoriteButton.backgroundColor = UIColor.redColor()
                self.addFavoriteButton.setTitle("Verwijder van favorieten", forState: .Normal)
            } else {
                self.addFavoriteButton.backgroundColor =  colorGreen
                self.addFavoriteButton.setTitle("Voeg toe aan favorieten", forState: .Normal)
            }
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
