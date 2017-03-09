//
//  SWItemStore.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 11/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class SWItemStore {
    var allItems = [[Item](), [Item]()]
    
    //function to create an item
    func createItem(name: String, money: Double) -> Item {
        let newItem = Item(name: name, money: money)
        if (newItem.money < 0){
            allItems[0].append(newItem)
        }
        else{
            allItems[1].append(newItem)
        }
        //allItems.append(newItem)
        //allItems.insert(newItem, atIndex: 0)
        return newItem
    }
    
    //function to remove specified item from the array
    func removeItem(item: Item) {
        if(item.money < 0){
            if let index = allItems[0].indexOf(item) {
                allItems[0].removeAtIndex(index)
            }
        }
        else{
            if let index = allItems[1].indexOf(item) {
                allItems[1].removeAtIndex(index)
            }
        }
    }
    
    //function to reorder an item in the array
    func moveItem(fromIndex: Int, toIndex: Int, srcIndexPath: Int) {
        
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[srcIndexPath][fromIndex]
        
        allItems[srcIndexPath].removeAtIndex(fromIndex)
        
        allItems[srcIndexPath].insert(movedItem, atIndex: toIndex)
        
    }
  
      
    //function to print all items in the array
    func printAllItems() {
        for i in 0...4 {
            print("name: \(allItems[0][i].name) value: \(allItems[0][i].money)")
        }
        for i in 0...4 {
            print("name: \(allItems[1][i].name) value: \(allItems[1][i].money)")
        }
        
    }
}
