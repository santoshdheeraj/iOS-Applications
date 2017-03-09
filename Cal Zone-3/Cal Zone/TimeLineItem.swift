//
//  TimeLineItem.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 12/1/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class TimeLineItem: NSObject {
    var place: String
    var timeStamp: String
    var latitude: String
    var longitude: String
    var address: String
    
    //designated Intializer
    init(place: String, timeStamp: String, latitude: String, longitude: String, address: String) {
        self.place = place
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        super.init()
    }
    
    
}
