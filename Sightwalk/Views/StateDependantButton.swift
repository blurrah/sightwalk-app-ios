//
//  StateDependantButton.swift
//  Sightwalk
//
//  Created by Boris Besemer on 27-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class StateDependantButton: UIButton {

    private var buttonState: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 2.0;
        self.backgroundColor = UIColor(red:0.64, green:0.64, blue:0.64, alpha:1)
        self.tintColor = UIColor.whiteColor()
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        self.enabled = self.buttonState
    }
    
    // TODO: Add enabling/disabling button tap handling
    
    func enableButton() {
        self.backgroundColor = UIColor(red:0.16862745100000001, green:0.7725490196, blue:0.36862745099999999, alpha:1)
        
        self.buttonState = true
        updateButtonState()
    }
    
    func disableButton() {
        self.backgroundColor = UIColor(red:0.64, green:0.64, blue:0.64, alpha:1)
        
        self.buttonState = false
        updateButtonState()
    }
    
    func updateButtonState() {
        self.enabled = self.buttonState
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
