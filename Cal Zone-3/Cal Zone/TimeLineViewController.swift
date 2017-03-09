//
//  TimeLineViewController.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 12/1/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Firebase

class TimeLineViewController: UITableViewController{
    
    var ref: FIRDatabaseReference!
    var itemStore = TimeLineItemStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        
        //tableView.rowHeight = 45
        
        tableView.estimatedRowHeight = 65
        navigationItem.title = "TimeLine"
        
        //print("font: \(UIApplication.sharedApplication().preferredContentSizeCategory)")
        print("TimeLineViewController did load")
        //configureView()
        //tableView.reloadData()
    }
    
    // rahul added
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        itemStore.timeLineItems.removeAll()
    }
    
    func configureView(){
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("CheckIns").child(userID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //print("Inner Dictionary is\(dictionary)"  )
                for (key, value) in dictionary
                {
                    let newItem = self.itemStore.createItem(value["place"] as! String, timeStamp: key, latitude: value["lat"] as! String, longitude: value["long"] as! String, address: value["address"] as! String)
                    if let index = self.itemStore.timeLineItems.indexOf(newItem) {
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    else{
                        print("Exception")
                    }
                }
            }
            else{
                print("Exception")
            }
            }, withCancelBlock: nil)

    }

    //function that changes delete text to remove
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    //function to get the number of sections in the table view.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //function to get the number of rows in a given section of a table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.timeLineItems.count
    }
    
    //function to get a cell for inserting in a particular location of the table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCell
        cell.updateLabels() //sets the fonts of the labels
        
        let item = itemStore.timeLineItems[indexPath.row]
        
        cell.placeLabel.text = item.place
        cell.timeLabel.text = item.timeStamp
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if segue.identifier == "ShowTimeLineItem" {
                    if let row = tableView.indexPathForSelectedRow?.row {
                        
                        let item = itemStore.timeLineItems[row]
        
                        let detailController = segue.destinationViewController as! mapDetailViewController
        
                        detailController.latitude = item.latitude
                        detailController.longitude = item.longitude
                        detailController.name = item.place
                        detailController.address = item.address
                        detailController.itemID = item.timeStamp
                    }
                }
        }
    
    @IBAction func unwindToTimeLineViewController(segue: UIStoryboardSegue){}
       
}


