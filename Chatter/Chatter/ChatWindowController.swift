//
//  ChatWindowController.swift
//  Chatter
//
//  Created by John Wheeler on 11/9/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private let ChatWindowControllerDidSendMessageNotification = "com.bignerdranch.chatter.ChatWindowControllerDidSendMessageNotification"
private let ChatWindowControllerMessageKey = "com.bignerdranch.chatter.ChatWindowControllerMessageKey"

class ChatWindowController: NSWindowController {
    
    dynamic var log: NSAttributedString = NSAttributedString(string: "")
    dynamic var message: String?

    @IBOutlet var textView: NSTextView!
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    override var windowNibName: String {
        return "ChatWindowController"
    }
    
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("receiveDidSendMessageNotification:"), name: ChatWindowControllerDidSendMessageNotification, object: nil)
    }
    
    @IBAction func send(sender: NSButton) {
        sender.window?.endEditingFor(nil)
        if let message = message {
            let userInfo = [ChatWindowControllerMessageKey: message]
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName(ChatWindowControllerDidSendMessageNotification, object: self, userInfo: userInfo)
        }
        message = ""
    }
    
    // MARK: - Notifications
    
    // ChatWindowControllerDidSendMessageNotification
    func receiveDidSendMessageNotification(note: NSNotification) {
        let mutableLog = log.mutableCopy()
        
        if log.length > 0 {
            mutableLog.appendAttributedString(NSAttributedString(string: "\n"))
        }
        
        let userInfo = note.userInfo! as! [String : String]
        let message = userInfo[ChatWindowControllerMessageKey]!
        
        let logLine = NSAttributedString(string: message)
        mutableLog.appendAttributedString(logLine)
        
        log = mutableLog.copy() as! NSAttributedString
        
        textView.scrollRangeToVisible(NSRange(location: log.length, length: 0))
    }
}
