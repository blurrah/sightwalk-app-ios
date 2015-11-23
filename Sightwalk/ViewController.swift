//
//  ViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 11-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.ß
//

import UIKit

class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    @IBAction func showWalktroughButtonPressed() {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walktrough = stb.instantiateViewControllerWithIdentifier("walk0") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2") as UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3") as UIViewController
        //let page_four = stb.instantiateViewControllerWithIdentifier("walk4") as UIViewController
        
        walktrough.delegate = self
        walktrough.addViewController(page_one)
        walktrough.addViewController(page_two)
        walktrough.addViewController(page_three)
        //walktrough.addViewController(page_four)
        
        self.presentViewController(walktrough, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

