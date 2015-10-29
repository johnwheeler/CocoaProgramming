//
//  AppDelegate.swift
//  Thermostat
//
//  Created by John Wheeler on 10/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create the window controller
        let mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)
        
        // Set the property to point to the window controller
        self.mainWindowController = mainWindowController
    }
}

