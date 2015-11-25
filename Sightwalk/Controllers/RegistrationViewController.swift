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
    let datepicker: UIDatePicker = UIDatePicker()
    let userDataStore = UserDataStore.sharedInstance
    
    @IBAction func registrationButtonAction(sender: AnyObject) {
        if ((swiftCop.anyGuilty()) && (self.lengthInputOutlet.text != "" || self.weightInputOutlet.text != "" || self.ageInputOutlet.text != "")) {
            JLToast.makeText("Gegevens kloppen niet, probeer opnieuw", delay: 0, duration: 2).show()
            return
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdate = dateFormatter.stringFromDate(self.datepicker.date)
        
        LoadingOverlayView.sharedInstance.showOverlayView(self.navigationController?.view)
        userDataStore.registerUser(self.usernameInputOutlet.text!, password: self.passwordInputOutlet.text!, email: self.emailInputOutlet.text!, weight: Int(self.weightInputOutlet.text!)!, length: Int(self.lengthInputOutlet.text!)!, birthdate: birthdate, onCompletion: { success, message in
            
            guard message == nil else {
                LoadingOverlayView.sharedInstance.hideOverlayView()
                JLToast.makeText(message!, delay: 0, duration: 2).show()
                return
            }
            
            self.userDataStore.getNewToken(self.usernameInputOutlet.text!, password: self.passwordInputOutlet.text!, onCompletion: { success, message in
                LoadingOverlayView.sharedInstance.hideOverlayView()
                
                if message != nil {
                    JLToast.makeText(message!, delay: 0, duration: 2).show()
                    return
                }
                
                self.goToDashboard()
                
            })
        })
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
        
        // add Datepicker
        
        self.datepicker.datePickerMode = UIDatePickerMode.Date
        self.datepicker.addTarget(self, action: Selector("onUpdateDatepicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.ageInputOutlet.inputView = datepicker
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onUpdateDatepicker(sender: AnyObject?) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateString = dateFormatter.stringFromDate((sender?.date)!)
        self.ageInputOutlet.text = dateString
    }
    
    func goToDashboard() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as UIViewController!
        presentViewController(vc, animated: true, completion: nil)
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
