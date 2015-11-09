//
//  ChatWindowController.swift
//  Chatter
//
//  Created by John Wheeler on 11/9/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ChatWindowController: NSWindowController {
    
    dynamic var log: NSAttributedString = NSAttributedString(string: "")
    dynamic var message: String?

    @IBOutlet var textView: NSTextView!
    
    override var windowNibName: String {
        return "ChatWindowController"
    }
    
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func send(sender: NSButton) {
    }
}
