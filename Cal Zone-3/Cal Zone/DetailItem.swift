//
//  Item.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 12/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import MapKit
import Firebase

class RestaurantDetailItem{
    var venue : Venue!
    
    var itemregion : MKCoordinateRegion?
    
    var itemannotation : CoffeeAnnotation?
    
    var ref: FIRDatabaseReference!
    
    var longitude: String?
    
    var latitude: String?
    
    var miles : Float = 1609.344
    
    var distance : String = ""
    
    //date formatter
    var dateFormatter: NSDateFormatter = {_ in
        let df = NSDateFormatter()
        df.dateStyle = .MediumStyle
        df.timeStyle = .MediumStyle
        return df
    }()
    
    var dateTime: String = ""
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    func setIcons(icon : Int, labeltext : String)-> NSAttributedString{
        let iconsSize = CGRect(x: 0, y: -5, width: 25, height: 25)
        let emojisCollection = [UIImage(named: "Restaurant"), UIImage(named: "Location"), UIImage(named: "Address"), UIImage(named: "Phone"), UIImage(named: "baby")]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let Attachment = NSTextAttachment()
        Attachment.image = emojisCollection[icon]
        Attachment.bounds = iconsSize
        attributedString.appendAttributedString(NSAttributedString(attachment: Attachment))
        attributedString.appendAttributedString(NSAttributedString(string: "   "))
        attributedString.appendAttributedString(NSAttributedString(string: labeltext))
        
        return attributedString
    }
}