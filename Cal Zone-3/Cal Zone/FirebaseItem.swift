//
//  FirebaseItem.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 12/5/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//


import Firebase

class FirbaseItem {
    var ref: FIRDatabaseReference!
    var user: FIRUser?
    init(us: FIRUser){
        ref = FIRDatabase.database().reference()
        user = us
    }
    
    // adding users to firebase
    func writetoUsers(values: [String: AnyObject]){
        self.ref.child("Users").child(user!.uid).setValue(values)
    }
    
    // adding check-ins to firebase
    func writetoCheckIn(date : String, values:[String: AnyObject]){
        self.ref.child("CheckIns").child(user!.uid).child(date).setValue(values)
    }
}