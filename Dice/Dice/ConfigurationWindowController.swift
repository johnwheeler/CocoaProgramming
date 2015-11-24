//
//  ConfigurationWindowController.swift
//  Dice
//
//  Created by John Wheeler on 11/23/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

struct DieConfiguration {
    let color: NSColor
    let rolls: Int
    
    init(color: NSColor, rolls: Int) {
        self.color = color
        self.rolls = max(rolls, 1)
    }
}

class ConfigurationWindowController: NSWindowController {
    
    var configuration: DieConfiguration {
        set {
            color = newValue.color
            rolls = newValue.rolls
        }
        get {
            return DieConfiguration(color: color, rolls: rolls)
        }
    }
    
    private dynamic var color: NSColor = NSColor.whiteColor()
    private dynamic var rolls: Int = 10
    
    override var windowNibName: String {
        return "ConfigurationWindowController"
    }
    
    @IBAction func okayButtonClicked(sender: NSButton) {
        window?.endEditingFor(nil)
        dismissWithModalResponse(NSModalResponseOK)
    }
    
    @IBAction func cancelButtonClicked(sender: NSButton){
        dismissWithModalResponse(NSModalResponseCancel)
    }
    
    func dismissWithModalResponse(response: NSModalResponse) {
        window!.sheetParent!.endSheet(window!, returnCode: response)
    }
    
    func presentAsSheetOnWindow(window: NSWindow, completionHandler handler: (DieConfiguration?) -> Void) {
        window.beginSheet(self.window!) {
            result in
            if result == NSModalResponseOK {
                handler(self.configuration)
            } else {
                handler(nil)
            }
        }
    }
}
