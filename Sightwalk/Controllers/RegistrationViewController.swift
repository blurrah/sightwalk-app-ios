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
    @IBOutlet var usernameErrorMessageOutlet: UILabel!
    @IBOutlet var passwordErrorMessageOutlet: UILabel!
    @IBOutlet var ageErrorMessageOutlet: UILabel!
    @IBOutlet var lengthErrorMessageOutlet: UILabel!
    @IBOutlet var weightErrorMessageOutlet: UILabel!
    
    let swiftCop = SwiftCop()
    
    @IBAction func registrationButtonAction(sender: AnyObject) {
        if ((swiftCop.anyGuilty()) && (self.lengthInputOutlet.text != "" || self.weightInputOutlet.text != "" || self.ageInputOutlet.text != "")) {
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
        swiftCop.addSuspect(Suspect(view:self.ageInputOutlet, sentence: "Ongeldige geboortedatum", trial: Trial.Format("(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[012])/((19|20)\\d\\d)")))
        swiftCop.addSuspect(Suspect(view:self.ageInputOutlet, sentence: "Gebruik '/' voor de scheiding", trial: Trial.Exclusion([".", "-"])))
        swiftCop.addSuspect(Suspect(view:self.lengthInputOutlet, sentence: "Alleen cijfers toegestaan", trial: Trial.Format("^[0-9]*$")))
        swiftCop.addSuspect(Suspect(view:self.lengthInputOutlet, sentence: "Minimaal 2 cijfers", trial: Trial.Length(.Minimum, 2)))
        swiftCop.addSuspect(Suspect(view:self.lengthInputOutlet, sentence: "Maximaal 3 cijfers", trial: Trial.Length(.Maximum, 3)))
        swiftCop.addSuspect(Suspect(view:self.weightInputOutlet, sentence: "Alleen cijfers toegestaan", trial: Trial.Format("^[0-9]*$")))
        swiftCop.addSuspect(Suspect(view:self.weightInputOutlet, sentence: "Minimaal 2 cijfers", trial: Trial.Length(.Minimum, 2)))
        swiftCop.addSuspect(Suspect(view:self.weightInputOutlet, sentence: "Maximaal 3 cijfers", trial: Trial.Length(.Maximum, 3)))
        swiftCop.addSuspect(Suspect(view:self.usernameInputOutlet, sentence: "Minimaal 3 karakters", trial: Trial.Length(.Minimum, 3)))
        swiftCop.addSuspect(Suspect(view:self.usernameInputOutlet, sentence: "Maximaal 10 karakters", trial: Trial.Length(.Maximum, 10)))
        swiftCop.addSuspect(Suspect(view:self.passwordInputOutlet, sentence: "Minimaal 5 karakters", trial: Trial.Length(.Minimum, 5)))
        swiftCop.addSuspect(Suspect(view:self.passwordInputOutlet, sentence: "Maximaal 20 karakters", trial: Trial.Length(.Maximum, 20)))
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
        self.usernameErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
            self.usernameInputOutlet.activateWarning()
        } else {
            self.usernameInputOutlet.deactivateWarning()
        }
    }
    
    @IBAction func validatePassword(sender: GenericTextField) {
        self.passwordErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
            self.passwordInputOutlet.activateWarning()
        } else {
            self.passwordInputOutlet.deactivateWarning()
        }
    }
    
    @IBAction func validateAge(sender: GenericTextField) {
        self.ageErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
            self.ageInputOutlet.activateWarning()
        } else {
            self.ageInputOutlet.deactivateWarning()
        }
    }
    
    @IBAction func validateLength(sender: GenericTextField) {
        self.lengthErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
            self.lengthInputOutlet.activateWarning()
        } else {
            self.lengthInputOutlet.deactivateWarning()
        }
    }
    
    @IBAction func validateWeight(sender: GenericTextField) {
        self.weightErrorMessageOutlet.text = swiftCop.isGuilty(sender)?.verdict()
        if (swiftCop.isGuilty(sender)?.verdict() != nil) {
            self.weightInputOutlet.activateWarning()
        } else {
            self.weightInputOutlet.deactivateWarning()
        }
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
