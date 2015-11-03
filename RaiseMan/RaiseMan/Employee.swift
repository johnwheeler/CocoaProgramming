//
//  Employee.swift
//  RaiseMan
//
//  Created by John Wheeler on 10/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Employee : NSObject {
    var name: String? = "New Employee"
    var raise: Float = 0.05
    
    func validateRaise(ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
        print("validateRaise called")
        
        let raiseNumber = ioValue.memory
        if raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
            throw NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }
}