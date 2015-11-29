//
//  AppDelegate.swift
//  ViewControl
//
//  Created by John Wheeler on 11/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // flow view
        let flowViewController = ImageViewController()
        flowViewController.title = "Flow"
        flowViewController.image = NSImage(named: NSImageNameFlowViewTemplate)
        
        // column view
        let columnViewController = ImageViewController()
        columnViewController.title = "Column"
        columnViewController.image = NSImage(named: NSImageNameColumnViewTemplate)
        
        // tab view
        let tabViewController = NSTabViewController()
        tabViewController.addChildViewController(flowViewController)
        tabViewController.addChildViewController(columnViewController)
        
        let window = NSWindow(contentViewController: tabViewController)
        window.makeKeyAndOrderFront(self)
        self.window = window
    }

}

