//
//  LoginViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameInputOutlet: GenericTextField!
    @IBOutlet var passwordInputOutlet: GenericTextField!
    
    @IBAction func tapGestureAction(sender: AnyObject) {
        usernameInputOutlet.resignFirstResponder()
        passwordInputOutlet.resignFirstResponder()
    }
    
    let userDataStore = UserDataStore.sharedInstance
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        userDataStore.getNewToken(self.usernameInputOutlet.text!, password: self.passwordInputOutlet.text!, onCompletion: { success, message in
            print("success is: \(success)")
            print("message is: \(message)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Inloggen"
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
