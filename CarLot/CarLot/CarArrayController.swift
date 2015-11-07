//
//  CarArrayController.swift
//  CarLot
//
//  Created by John Wheeler on 11/7/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func newObject() -> AnyObject {
        let newObj = super.newObject() as! NSObject
        let now = NSDate()
        newObj.setValue(now, forKey: "datePurchased")
        return newObj
    }
    
    // MARK: - Actions
    
    // X-tra credit :-)
    @IBAction func addCar(sender: NSButton) {
        let car = newObject() as! NSObject
        addObject(car)
        rearrangeObjects()
        let sortedCars = arrangedObjects as! [NSObject]
        let row = sortedCars.indexOf(car)!
        tableView.editColumn(0, row: row, withEvent: nil, select: true)
    }
}
