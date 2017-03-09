//
//  RestaurantItem.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 12/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import MapKit

class RestaurantItem {
    // User location Attributes
    var locationManager:CLLocationManager?
    
    let distanceSpan:Double = 3000
    
    var lastLocation:CLLocation?
    
    var venues:[Venue]?
    
    var region: MKCoordinateRegion?
    
    var annotation: CoffeeAnnotation?
    
    var miles : Float = 1609.344
    
    var distance : String = ""

}
