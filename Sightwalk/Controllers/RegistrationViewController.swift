//
//  RegistrationViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import JLToast
import SwiftCop

class RegistrationViewController: UIViewController {
    @IBOutlet var emailInputOutlet: GenericTextField!
    @IBOutlet var usernameInputOutlet: GenericTextField!
    @IBOutlet var passwordInputOutlet: GenericTextField!
    @IBOutlet var ageInputOutlet: GenericTextField!
    @IBOutlet var lengthInputOutlet: GenericTextField!
    @IBOutlet var weightInputOutlet: GenericTextField!
    @IBOutlet var bottomViewConstraintOutlet: NSLayoutConstraint!
    
    @IBOutlet var emailErrorMessageOutlet: UILabel!
    @IBOutlet weak var emailMessageOutlet: UILabel!
    let swiftCop = SwiftCop()
    
    @IBAction func registrationButtonAction(sender: AnyObject) {
        if (swiftCop.anyGuilty()) {
            JLToast.makeText("Gegevens kloppen niet, probeer opnieuw", delay: 0, duration: 2).show()
        }
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
        
        swiftCop.addSuspect(Suspect(view:self.emailInputOutlet, sentence: "Ongeldige email", trial: Trial.Email))
        swiftCop.addSuspect(Suspect(view:self.ageInputOutlet, sentence: "Minimum 1 karakter", trial: Trial.Length(.Minimum, 1)))
        swiftCop.addSuspect(Suspect(view:self.ageInputOutlet, sentence: "Maximum 3 karakters", trial: Trial.Length(.Maximum, 3)))
        swiftCop.addSuspect(Suspect(view:self.lengthInputOutlet, sentence: "Minimum 2 karakters", trial: Trial.Length(.Minimum, 2)))
        swiftCop.addSuspect(Suspect(view:self.lengthInputOutlet, sentence: "Maximum 3 karakters", trial: Trial.Length(.Maximum, 3)))
        swiftCop.addSuspect(Suspect(view:self.weightInputOutlet, sentence: "Minimum 2 karakters", trial: Trial.Length(.Minimum, 2)))
        swiftCop.addSuspect(Suspect(view:self.weightInputOutlet, sentence: "Maximum 3 karakters", trial: Trial.Length(.Maximum, 3)))
        swiftCop.addSuspect(Suspect(view:self.usernameInputOutlet, sentence: "Minimum 3 karakters", trial: Trial.Length(.Minimum, 3)))
        swiftCop.addSuspect(Suspect(view:self.usernameInputOutlet, sentence: "Maximum 10 karakters", trial: Trial.Length(.Maximum, 10)))
        swiftCop.addSuspect(Suspect(view:self.passwordInputOutlet, sentence: "Minimaal 5 karakters", trial: Trial.Length(.Minimum, 5)))
        swiftCop.addSuspect(Suspect(view:self.passwordInputOutlet, sentence: "Maximum 20 karakters", trial: Trial.Length(.Maximum, 20)))
    }
    
    @IBAction func validateEmail(sender: GenericTextField) {
        self.emailErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
                self.emailInputOutlet.activateWarning()
            } else {
                self.emailInputOutlet.deactivateWarning()
            }
    }
    
    @IBAction func validateUsername(sender: GenericTextField) {
    }
    
    @IBAction func validatePassword(sender: GenericTextField) {
    }
    
    @IBAction func validateAge(sender: GenericTextField) {
    }
    
    @IBAction func validateLength(sender: GenericTextField) {
    }
    
    @IBAction func validateWeight(sender: GenericTextField) {
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
