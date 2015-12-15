//
//  AddSightButton.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 15/12/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Foundation

class AddSightButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 11
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
