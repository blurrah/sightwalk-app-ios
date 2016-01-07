//
//  InvertedGenericViewButton.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 25/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Foundation

class InvertedGenericViewButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 2.0;
        self.backgroundColor = UIColor.whiteColor()
        self.tintColor = UIColor(red:0.102, green:0.788, blue:0.341, alpha:1)
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