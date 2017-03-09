//
//  TimeLineCell.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 12/1/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell{
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        placeLabel.font = bodyFont
        timeLabel.font = bodyFont
        
    }
}
