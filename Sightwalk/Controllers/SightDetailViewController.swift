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
        
        self.titleBar.title = currentSight!.title
        self.sightNameLabel.text = currentSight!.title
        self.sightTextView.text = currentSight!.text
        self.sightTextView.editable = false
        
        ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
            self.sightImageView.image = UIImage(data: response)
        })
        
        changeFavoriteButtonText()
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
}