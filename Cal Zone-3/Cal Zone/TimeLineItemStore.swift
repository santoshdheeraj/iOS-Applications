//
//  TimeLineItemStore.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 12/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class TimeLineItemStore{
    var timeLineItems = [TimeLineItem]()
    
    func createItem(place: String, timeStamp: String, latitude: String, longitude: String, address: String) -> TimeLineItem{
        let newItem = TimeLineItem(place: place, timeStamp: timeStamp, latitude: latitude, longitude: longitude, address: address)
        timeLineItems.append(newItem)
        return newItem
    }
    
}
