//
//  GenericTextField.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class GenericTextField: UITextField {
    
    let bottomBorder = CALayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height + 29, 400, 1.0)
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        self.layer.addSublayer(bottomBorder)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        
    }
    */
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 20, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 20, 10)
    }
    
    func activateWarning() {
        bottomBorder.backgroundColor = UIColor.redColor().CGColor
    }
    
    func deactivateWarning() {
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
    }
}
