//
//  AppDelegate.swift
//  Chatter
//
//  Created by John Wheeler on 11/9/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowControllers: [ChatWindowController] = []

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        addWindowController()
    }

    func applicationWillTerminate(aNotification: NSNotification) {

    }

    // MARK: - Helpers
    
    func addWindowController() {
        let windowController = ChatWindowController()
        windowController.showWindow(self)
        windowControllers.append(windowController)
    }
    
    @IBAction func displayNewWindow(sender: NSMenuItem) {
        addWindowController()
    }
}

