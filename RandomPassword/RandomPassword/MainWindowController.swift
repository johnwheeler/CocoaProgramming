//
//  MainWindowController.swift
//  RandomPassword
//
//  Created by John Wheeler on 10/27/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var textField: NSTextField!
    
    override var windowNibName: String? {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func generatePassword(sender: AnyObject) {
        // Generate a random string of length 8
        let length = 8
        let password = generateRandomString(length)
        
        // Tell the text field what to display
        textField.stringValue = password
    }
}
