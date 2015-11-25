//
//  ViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 11-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.ß
//

import UIKit

class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walktrough = stb.instantiateViewControllerWithIdentifier("walk0") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2") as UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3") as UIViewController
        
        walktrough.delegate = self
        walktrough.addViewController(page_one)
        walktrough.addViewController(page_two)
        walktrough.addViewController(page_three)
        self.presentViewController(walktrough, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

