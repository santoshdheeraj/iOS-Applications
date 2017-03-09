//
//  RegisterViewController.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 11/18/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var reEnterPasswordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //var userId: String!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        if firstNameField.text == "" || lastNameField.text == "" || genderField.text == "" || emailField.text == "" || passwordField.text == "" || reEnterPasswordField.text == ""
        {
            errorLabel.text = "Please fill all details"
        }
            
        else
        {
            if( passwordField.text == reEnterPasswordField.text){
                FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                    
                    if error == nil
                    {
                        // Upload User Data to Database https://cal-zone.firebaseio.com/
                        
                        let firstname: String = self.firstNameField.text!
                        let lastname:  String = self.lastNameField.text!
                        let gender:    String = self.genderField.text!
                        let email:     String = self.emailField.text!
                        let fbItem = FirbaseItem(us: user!)
                        
                        fbItem.writetoUsers(["firstname": firstname, "lastname": lastname, "gender": gender, "email": email])
                        
                        self.performSegueWithIdentifier("registerSuccess", sender: self)  // Register Success - Going into the app
                    }
                    else
                    {
                        self.errorLabel.text = error?.localizedDescription
                    }
                    
                }
            }
            else{
                self.errorLabel.text = "Passwords do not match"
            }
        }
        
    }
    
    // Background Tap Guesture Recognizer
    @IBAction func tap(sender: UITapGestureRecognizer) {
        resignKeyboard()
    }
    
    // Pressing Return Key on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        resignKeyboard()
        return true
    }
    
    // Resign First Responder Help function
    func resignKeyboard(){
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        genderField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        reEnterPasswordField.resignFirstResponder()
    }
}
