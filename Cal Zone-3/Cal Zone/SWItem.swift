//
//  SWItem.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var money: Double
    
    //designated Intializer
    init(name: String, money: Double) {
        self.name = name
        self.money = money
        super.init()
    }
    
    //convenience initializer
    convenience init(random: Bool) {
        if random {
            let adjectives = ["Shiny", "Rusty", "Fluffy"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var index = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(index)]
            
            index = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(index)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            
            let randomMoney = Double(arc4random_uniform(101))
            self.init(name: randomName, money: randomMoney)
            
        }
        else {
            self.init(name: "", money: 0)
        }
    }
    
}

