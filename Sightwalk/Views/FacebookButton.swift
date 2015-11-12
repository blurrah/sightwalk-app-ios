//
//  FacebookButton.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class FacebookButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 2.0;
        self.backgroundColor = UIColor(colorLiteralRed:0.22, green:0.33, blue:0.6, alpha:1)
        self.tintColor = UIColor.whiteColor()
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

