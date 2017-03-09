//
//  ProfileViewController.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 11/21/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var Gender: UILabel!
    
    var ref: FIRDatabaseReference!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Profile"
        navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem!.title = "Back"
    }
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
     
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref.child("Users").child(userID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
            
                self.firstName.text = String(dictionary["firstname"]!)
                self.lastName.text! = String(dictionary["lastname"]!)
                self.Gender.text! = String(dictionary["gender"]!)
                
                if(String(dictionary["gender"]!) == "Male" || String(dictionary["gender"]!) == "male"){
                    self.iconImage.image = UIImage(named: "male")
                }
                else{
                    self.iconImage.image = UIImage(named: "female")
                }
            }
            }, withCancelBlock: nil)
        
        super.viewDidLoad()
    }
    
    // Sign out User
    @IBAction func logOut(sender: AnyObject) {
        
        let title = "LogOut"
        let message = "Are you sure you want to Logout?"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Yes",
                                         style: .Destructive,
                                         handler: {_ in
                                            let firebaseAuth = FIRAuth.auth()
                                            do {
                                                try firebaseAuth?.signOut()
                                                self.performSegueWithIdentifier("logoutSuccess", sender: self)
                                                
                                            } catch let signOutError as NSError {
                                                print ("Error signing out: %@", signOutError)
                                            }
                                        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
        
        
    }
    
}
