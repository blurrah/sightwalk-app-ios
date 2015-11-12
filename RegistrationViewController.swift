//
//  RegistrationViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 12-11-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet var emailInputOutlet: GenericTextField!
    @IBOutlet var usernameInputOutlet: GenericTextField!
    @IBOutlet var passwordInputOutlet: GenericTextField!
    @IBOutlet var ageInputOutlet: GenericTextField!
    @IBOutlet var lengthInputOutlet: GenericTextField!
    @IBOutlet var weightInputOutlet: GenericTextField!
    
    
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

        // Do any additional setup after loading the view.
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
