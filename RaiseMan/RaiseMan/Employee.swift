//
//  Employee.swift
//  RaiseMan
//
//  Created by John Wheeler on 10/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Employee : NSObject, NSCoding {
    var name: String? = "New Employee"
    var raise: Float = 0.05
    
    override init() {
        super.init()
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String?
        raise = aDecoder.decodeFloatForKey("raise")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let name = name {
            aCoder.encodeObject(name, forKey: "name")
        }
        aCoder.encodeFloat(raise, forKey: "raise")
    }
    
    // MARK: - Key/Value validation
    
    func validateRaise(ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
        let raiseNumber = ioValue.memory
        if raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
            throw NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }
}