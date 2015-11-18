//
//  NSString+Drawing.swift
//  Dice
//
//  Created by John Wheeler on 11/18/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

extension NSString {
    
    func drawCenteredInRect(rect: NSRect, attributes: [String: AnyObject]!) {
        let stringSize = sizeWithAttributes(attributes)
        let point = NSPoint(x: rect.origin.x + (rect.width - stringSize.width) / 2.0,
                            y: rect.origin.y + (rect.height - stringSize.height) / 2.0)
        drawAtPoint(point, withAttributes: attributes)
    }
}
