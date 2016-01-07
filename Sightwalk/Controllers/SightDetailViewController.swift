//
//  SightDetailViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 07-01-16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class SightDetailViewController: UIViewController {
    
    var sightId: Int?
    @IBOutlet var titleBarOutlet: UINavigationItem!
    @IBOutlet var imageView: UIImageView!
    private var currentSight : Sight?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSight(sight : Sight) {
        currentSight = sight
        updateView()
    }
    
    func triggerLeaveSight() {
        print("leaving sight")
    }
    
    private func updateView() {
        self.titleBarOutlet.title = currentSight!.title
        
        ImageDownloadHelper.downloadImage(currentSight!.imgurl, onCompletion: { response in
            self.imageView.image = UIImage(data: response)
        })
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
