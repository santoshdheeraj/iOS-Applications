//
//  SWItemCell.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class SWItemCell: UITableViewCell{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        moneyLabel.font = bodyFont
        
    }
}


