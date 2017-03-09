//
//  AddBill.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import Contacts

class SWAddBill: UITableViewController{
    
    //var detailViewController: contactDetailViewController? = nil
    var objects = [CNContact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pick Contact"
        // Do any additional setup after loading the view, typically from a nib.
//        let addExisting = UIBarButtonItem(title: "Add Existing", style: .Plain, target: self, action: "addExistingContact")
//        self.navigationItem.leftBarButtonItem = addExisting
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? contactDetailViewController
//        }
        //self.detailViewController = destinationvi? as contactDetailViewController
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertNewObject:", name: "addNewContact", object: nil)
        //self.detailViewController = UIViewController? as contactDetailViewController
        self.getContacts()
    }
    
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            })
        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
            self.retrieveContactsWithStore(store)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
//            let groups = try store.groupsMatchingPredicate(nil)
//            
//            let predicate = CNContact.predicateForContactsInGroupWithIdentifier(groups[0].identifier)
//            //let predicate = CNContact.predicateForContactsMatchingName("John")
//            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey]
//            
//            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                               CNContactEmailAddressesKey,
                               CNContactPhoneNumbersKey,
                               CNContactImageDataAvailableKey,
                               CNContactThumbnailImageDataKey]
            var allContainers:[CNContainer] = []
            do {
                allContainers = try store.containersMatchingPredicate(nil)
            }catch {
                print(error)
            }
            
            for container in allContainers{
                let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                do {
                    let containerResults = try store.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                    self.objects.appendContentsOf(containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
        }
    }

    
    func addExistingContact() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: NSNotification) {
        if let contact = sender.userInfo?["contactToAdd"] as? CNContact {
            objects.insert(contact, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showContact" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = segue.destinationViewController as! contactDetailViewController
                let contactName = CNContactFormatter().stringFromContact(object)!.stringByReplacingOccurrencesOfString(".", withString: "")
                print(contactName)
                controller.fName = contactName
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = self.objects[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.textLabel?.text = formatter.stringFromContact(contact)
        cell.detailTextLabel?.text = contact.emailAddresses.first?.value as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}