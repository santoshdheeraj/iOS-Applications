//
//  contactDetailViewController.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Contacts
import Firebase

class contactDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var moneyTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    var moneyFactor: Double = -1.0
  
    var fName: String = ""
  
    var pickerDataSource = ["You owe them full", "They owe you in full", "Split the bill in half & paid by you", "Split the bill in half & paid by them"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        navigationItem.title = "Add Bill"
    }
    
    func configureView() {
        fullName.text = fName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        moneyFactor = -1.0
    }
    
    // Pressing Return Key on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        self.moneyTextField.resignFirstResponder()
        
        return true
    }
    
    // Background Tap Guesture Recognizer
    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        moneyTextField.resignFirstResponder()
        
    }
    
    @IBAction func doneButton(sender: AnyObject){
        ref = FIRDatabase.database().reference()
        //let userID = FIRAuth.auth()?.currentUser?.uid
        var finalMoney: Double = 0
        let moneyTF:Double = (Double(self.moneyTextField.text!) != nil) ? Double(self.moneyTextField.text!)! : 0
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //self.ref.child("Splitwise").child("\(userID)/\(fName)").setValue(finalMoney)
        
        ref.child("Splitwise").child(userID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                //print("Dictionary is\(dictionary)"  )
                if let money = dictionary["Money"] as? Double{
                    //print(money)
                    finalMoney = money + (self.moneyFactor * moneyTF)
                    self.ref.child("Splitwise").child("\(userID!)/Money").setValue(finalMoney)
                }
                else{
                    print("Exception in unwrapping money")
                }
            }
            else{
                self.ref.child("Splitwise").child("\(userID!)/Money").setValue(self.moneyFactor * moneyTF)
            }
            }, withCancelBlock: nil)
        
        ref.child("Splitwise").child(userID!).child(fName).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //print("Inner Dictionary is\(dictionary)"  )
                if let money = dictionary["Money"] as? Double{
                    //print("Money factor is \(self.moneyFactor)")
                    finalMoney = money + (self.moneyFactor * moneyTF)
                    let updateChildData = ["Money": finalMoney]
                    let childUpdates = ["/Splitwise/\(userID!)/\(self.fullName.text!)": updateChildData]
                    self.ref.updateChildValues(childUpdates)
                }
                else{
                    print("Exception in unwrapping money")
                }
            }
            else{
                finalMoney = self.moneyFactor * moneyTF     
                self.ref.child("Splitwise").child("\(userID!)/\(self.fName)/Money").setValue(finalMoney)
            }
            }, withCancelBlock: nil)
        
            self.performSegueWithIdentifier("unwindToSWItemsViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToSWItemsViewController" {
            let controller = segue.destinationViewController as! SWItemsViewController
            controller.checkString = "Check"
            //controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {   // You owe them full
            self.view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            moneyFactor = -1;
        }
        else if(row == 1)
        {
            // They owe you in full
            self.view.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.26, alpha:1.0)
            moneyFactor = 1
        }
        else if(row == 2)
        {
            // Split the bill & paid by you
            self.view.backgroundColor =  UIColor(red:0.51, green:0.78, blue:0.52, alpha:1.0)
            moneyFactor = 0.5
        }
        else if(row == 3)
        {
            // Split the bill & paid by them
            self.view.backgroundColor =  UIColor(red:0.40, green:0.73, blue:0.42, alpha:1.0)
            moneyFactor = -0.5
        }
        else
        {
            self.view.backgroundColor = UIColor.blueColor();
        }
    }
    
}