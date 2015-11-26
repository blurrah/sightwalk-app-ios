//
//  LoginViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import JLToast
import SwiftCop

class LoginViewController: UIViewController {

    @IBOutlet var usernameInputOutlet: GenericTextField!
    @IBOutlet var passwordInputOutlet: GenericTextField!
    
    @IBAction func tapGestureAction(sender: AnyObject) {
        usernameInputOutlet.resignFirstResponder()
        passwordInputOutlet.resignFirstResponder()
    }
    
    let userDataStore = UserDataStore.sharedInstance
    
    @IBAction func forgotPasswordButtonAction(sender: AnyObject) {
        let alert : UIAlertController = UIAlertController(title: "Wachtwoord resetten", message: "Vul hieronder uw e-mailadres in om uw wachtwoord te resetten.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "E-mailadres"
        }
        
        alert.addAction(UIAlertAction(title: "Verzend", style: UIAlertActionStyle.Default)  {alertAction in
            let textField = alert.textFields![0] as UITextField
            LoadingOverlayView.sharedInstance.showOverlayView(alert.view)
            self.userDataStore.resetPassword(textField.text!, onCompletion: { success, message in
                LoadingOverlayView.sharedInstance.hideOverlayView()
                
                if (self.isValidEmail(textField.text!) == false) {
                    JLToastView.setDefaultValue(UIColor.redColor(),
                        forAttributeName: JLToastViewBackgroundColorAttributeName,
                        userInterfaceIdiom: .Phone)
                    JLToast.makeText("De ingevoerde e-mail is niet geldig", delay: 0, duration: 2).show()
                    return
                }
                
                if message != nil {
                    JLToastView.setDefaultValue(UIColor.redColor(),
                    forAttributeName: JLToastViewBackgroundColorAttributeName,
                    userInterfaceIdiom: .Phone)
                    JLToast.makeText(message!, delay: 0, duration: 2).show()
                    return
                }
                
                JLToastView.setDefaultValue(UIColor.greenColor(),
                    forAttributeName: JLToastViewBackgroundColorAttributeName,
                    userInterfaceIdiom: .Phone)
                JLToast.makeText("Check uw e-mail om uw wachtwoord te resetten!", delay: 0, duration: 2).show()
            })
        })
        
        alert.addAction(UIAlertAction(title: "Annuleer", style: UIAlertActionStyle.Cancel) {alertAction in
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        LoadingOverlayView.sharedInstance.showOverlayView(navigationController?.view)
        userDataStore.getNewToken(self.usernameInputOutlet.text!, password: self.passwordInputOutlet.text!, onCompletion: { success, message in
            LoadingOverlayView.sharedInstance.hideOverlayView()
            
            if message != nil {
                JLToast.makeText(message!, delay: 0, duration: 2).show()
                return
            }
            
            self.goToDashboard()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        JLToastView.setDefaultValue(UIColor.redColor(), forAttributeName:JLToastViewBackgroundColorAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(80, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Inloggen"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToDashboard() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as UIViewController!
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
