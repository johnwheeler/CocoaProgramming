//
//  MainWindowController.swift
//  Dice
//
//  Created by John Wheeler on 11/11/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func showDieConfiguration(sender: AnyObject?) {
        if let window = window, let dieView = window.firstResponder as? DieView {
            let windowController = ConfigurationWindowController()
            windowController.configuration = DieConfiguration(color: dieView.color, rolls: dieView.numberOfTimesToRoll)
            
            windowController.presentAsSheetOnWindow(window) {
                configuration in
                if let configuration = configuration {
                    dieView.color = configuration.color
                    dieView.numberOfTimesToRoll = configuration.rolls
                }
            }
        }
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case Selector("showDieConfiguration:"):
            return window?.firstResponder is DieView
        default:
            return true
        }
    }
}
