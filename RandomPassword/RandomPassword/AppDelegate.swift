//
//  AppDelegate.swift
//  RandomPassword
//
//  Created by John Wheeler on 10/27/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create a window controller with a XIB of the same name
        let mainWindowController = MainWindowController()
        
        // Put the window of the controller on the screen
        mainWindowController.showWindow(self)
        
        // Set the property to point to the window controller
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

