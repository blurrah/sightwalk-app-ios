//
//  GenericNavigationBar.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class GenericNavigationBar: UINavigationBar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.barTintColor = UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1)
        
        self.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.titleTextAttributes = titleDict as? [String : AnyObject]
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
