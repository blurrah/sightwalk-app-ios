//
//  SightShowViewController.swift
//  Sightwalk
//
//  Created by frank kuipers on 1/7/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit

class SightShowViewController: UIViewController {

    private var currentSight : Sight?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
    }

}
