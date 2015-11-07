//
//  CarArrayController.swift
//  CarLot
//
//  Created by John Wheeler on 11/7/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {

    override func newObject() -> AnyObject {
        let newObj = super.newObject() as! NSObject
        let now = NSDate()
        newObj.setValue(now, forKey: "datePurchased")
        return newObj
    }
}
