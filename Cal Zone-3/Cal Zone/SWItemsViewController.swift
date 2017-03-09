//
//  SWItemsViewController.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

//
//  ItemsViewController.swift
//  Homeowner
//
//  Created by teacher on 10/18/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Firebase

class SWItemsViewController: UITableViewController {
    var iter: Int = 0
    var itemStore = SWItemStore()
    var ref: FIRDatabaseReference!
    var checkString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        
        //tableView.rowHeight = 45
        
        tableView.estimatedRowHeight = 65
        navigationItem.title = "SplitWise"
        
        //print("font: \(UIApplication.sharedApplication().preferredContentSizeCategory)")
        //print("SWItemsViewController did load")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        itemStore.allItems[0].removeAll()
        itemStore.allItems[1].removeAll()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //itemStore = SWItemStore()
//        itemStore.allItems[0].removeAll()
//        itemStore.allItems[1].removeAll()
        configureView()
        tableView.reloadData()
        //print("SWItemsViewController did appear")
    }
    
    func configureView(){
        var iter:Int = 0
        var itemExists:Int = 0
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Splitwise").child(userID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                for (key, value) in dictionary
                {
                    if key != "Money"{
                        itemExists = 0
                        let val: Double = (value["Money"] as? Double)!
                        //print("Key is \(key) and value is \(val)")
                        let firstLength: Int = self.itemStore.allItems[0].count
                        let secondLength: Int = self.itemStore.allItems[1].count
                        iter = 0
                        self.tableView.reloadData()
                        while iter < firstLength{
                            if(self.itemStore.allItems[0][iter].name == key){
                                itemExists = 1
                                if(self.itemStore.allItems[0][iter].money != val){
                                   self.itemStore.allItems[0][iter].money = val
                                    break
                                }
                            }
                            iter = iter + 1
                        }
                        if(itemExists < 1){
                            iter = 0
                            while iter < secondLength{
                                if(self.itemStore.allItems[1][iter].name == key){
                                    itemExists = 1
                                    if(self.itemStore.allItems[1][iter].money != val){
                                        self.itemStore.allItems[1][iter].money = val
                                        break
                                    }
                                }
                                iter = iter + 1
                            }
                        }
                        if(itemExists < 1){
                            let newItem = self.itemStore.createItem(key, money: val)
                            if (val < 0){
                                iter = 0
                            }
                            else{
                                iter = 1
                            }
                            if let index = self.itemStore.allItems[iter].indexOf(newItem) {
                                let indexPath = NSIndexPath(forRow: index, inSection: iter)
                                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                            }
                            else{
                                print("Exception")
                            }
                        }
                        
                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.tableView.reloadData()
//                        })
//                        if val > 0{
//                            self.iter = 1
//                        }
//                        else{
//                            self.iter = 0
//                        }
//                        if let index = self.itemStore.allItems[self.iter].indexOf(newItem) {
//                            let indexPath = NSIndexPath(forRow: index, inSection: self.iter)
//                            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                        }
                        //print(self.itemStore.allItems[0][0].name, self.itemStore.allItems[0][0].name.key)
                    }
                }
            }
            else{
                print("This user has no splitwise balances")
            }
        }, withCancelBlock: nil)
//        print("Item Store is \(itemStore)")
//        dispatch_async(dispatch_get_main_queue(), {
//            self.tableView.reloadData()
//        })
    }
    
    
    //IBAction for "Add" button
    @IBAction func addNewItem(button: UIButton) {
        
//        let newItem = itemStore.createItem()
//        if (newItem.money < 0){
//            iter = 0
//        }
//        else{
//            iter = 1
//        }
//        if let index = itemStore.allItems[iter].indexOf(newItem) {
//            let indexPath = NSIndexPath(forRow: index, inSection: iter)
//            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        }
        print(checkString)
    }
    //IBAction for "Edit" button
    @IBAction func toggleEditingMode(button: UIButton) {
        //        tableView.editing = true //sets editing property of UITableView
        //        setEditing(true, animated: true) //sets editing property of ItemsViewController
        //
        //        print("ItemsViewController editing: \(editing)")
        //        print("tableView editing: \(tableView.editing)")
        
        if editing {
            setEditing(false, animated: true)
            button.setTitle("Edit", forState: .Normal)
        }
        else {
            setEditing(true, animated: true)
            button.setTitle("Done", forState: .Normal)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "You owe"
        }
        else{
            return "You are owed"
        }
   }
    
    //function that commits the editing style of a specified row.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //print("Trying to delete Section: \(indexPath.section) Row: \(indexPath.row)").
            let item = itemStore.allItems[indexPath.section][indexPath.row]
            
            let title = "Delete \(item.name)?"
            
            let message = "Are you sure?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .Destructive,
                                             handler: {_ in
                                                self.itemStore.allItems[indexPath.section].removeAtIndex(indexPath.row)
                                                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            
            ac.addAction(deleteAction)
            
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    //function
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //function that returns a new index path to retarget a proposed move of a row.
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section{
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    //function that enables row reordering
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        itemStore.moveItem(sourceIndexPath.row, toIndex: destinationIndexPath.row, srcIndexPath:sourceIndexPath.section)
    }
    
    //function that changes delete text to remove
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    //function to get the number of sections in the table view.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //function to get the number of rows in a given section of a table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return itemStore.allItems[0].count
        }
        else {
            return itemStore.allItems[1].count
        }
    }
    
    //function to get a cell for inserting in a particular location of the table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("I am being called")
        //print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SWItemCell", forIndexPath: indexPath) as! SWItemCell
        cell.updateLabels() //sets the fonts of the labels
        
        let item = itemStore.allItems[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.moneyLabel.text = "$\(item.money)"
        if(item.money < 0){
            cell.moneyLabel.textColor = UIColor.redColor()
        }
        else{
            cell.moneyLabel.textColor = UIColor.greenColor()
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowItem" {
//            if let row = tableView.indexPathForSelectedRow?.row {
//                let indexSection = tableView.indexPathForSelectedRow?.section
//                let item = itemStore.allItems[indexSection!][row]
//                
//                let detailController = segue.destinationViewController as! SWDetailViewController
//                
//                detailController.item = item
//            }
//        }
        if segue.identifier == "AddExistingBill"{
            if let row = tableView.indexPathForSelectedRow?.row {
                let indexSection = tableView.indexPathForSelectedRow?.section
                let item = itemStore.allItems[indexSection!][row]
                let controller = segue.destinationViewController as! contactDetailViewController
                controller.fName = item.name
            }

        }
    }
    
    @IBAction func unwindToSWItemsViewController(segue: UIStoryboardSegue){}
    
    
    
}

