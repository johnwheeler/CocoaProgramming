//
//  AppDelegate.swift
//  ImageTiling
//
//  Created by John Wheeler on 11/12/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(aNotification: NSNotification) {

    }

}

