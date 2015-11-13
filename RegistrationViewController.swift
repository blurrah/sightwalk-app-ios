//
//  RegistrationViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import JLToast

class RegistrationViewController: UIViewController {
    @IBOutlet var emailInputOutlet: GenericTextField!
    @IBOutlet var usernameInputOutlet: GenericTextField!
    @IBOutlet var passwordInputOutlet: GenericTextField!
    @IBOutlet var ageInputOutlet: GenericTextField!
    @IBOutlet var lengthInputOutlet: GenericTextField!
    @IBOutlet var weightInputOutlet: GenericTextField!
    @IBOutlet var bottomViewConstraintOutlet: NSLayoutConstraint!
    
    @IBAction func registrationButtonAction(sender: AnyObject) {
        JLToast.makeText("Gegevens kloppen niet, probeer opnieuw", delay: 0, duration: 2).show()
    }
    
    @IBAction func tapGestureAction(sender: AnyObject) {
        emailInputOutlet.resignFirstResponder()
        usernameInputOutlet.resignFirstResponder()
        passwordInputOutlet.resignFirstResponder()
        ageInputOutlet.resignFirstResponder()
        lengthInputOutlet.resignFirstResponder()
        weightInputOutlet.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JLToastView.setDefaultValue(UIColor.redColor(), forAttributeName:JLToastViewBackgroundColorAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(80, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Registreren"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
