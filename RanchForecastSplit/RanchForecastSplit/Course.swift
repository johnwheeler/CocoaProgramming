//
//  Course.swift
//  RanchForcast
//
//  Created by John Wheeler on 11/28/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Course: NSObject {
    let title: String
    let url: NSURL
    let nextStartDate: NSDate
        
    init(title: String, url: NSURL, nextStartDate: NSDate) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}