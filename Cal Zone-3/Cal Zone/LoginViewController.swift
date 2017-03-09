//
//  LoginViewController.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 11/1/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        self.textFieldLoginEmail.center.x  -= view.bounds.width
        self.textFieldLoginPassword.center.x -= view.bounds.width
        UIView.animateWithDuration(0.5, delay: 0.4, options: [], animations: {
            self.textFieldLoginEmail.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.6, options: [], animations: {
            self.textFieldLoginPassword.center.x += self.view.bounds.width
            }, completion: nil)
        super.viewDidAppear(animated)
    }
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    @IBOutlet weak var errorFieldLabel: UILabel!
    
    // Login the User using firebase
    @IBAction func loginButton(sender: AnyObject) {
        if textFieldLoginEmail.text == "" || textFieldLoginPassword.text == ""
        {
            errorFieldLabel.text = "Please Enter Email and Password"
        }
        else
        {
            FIRAuth.auth()?.signInWithEmail(textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
                
                if error == nil
                {
                    self.performSegueWithIdentifier("loginSuccess", sender: self)  // Login Success - Going into the app
                    
                }
                else
                {
                    self.errorFieldLabel.text = error?.localizedDescription
                }
                
            }
        }
    }
    
    // Background Tap Guesture Recognizer
    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        textFieldLoginEmail.resignFirstResponder()
        textFieldLoginPassword.resignFirstResponder()
        
    }
    
    // Pressing Return Key on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        self.textFieldLoginEmail.resignFirstResponder()
        self.textFieldLoginPassword.resignFirstResponder()
        
        return true
    }
    
}
