//
//  MainWindowController.swift
//  Thermostat
//
//  Created by John Wheeler on 10/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    private var privateTemperature = 68
    dynamic var temperature: Int {
        set {
            print("set temperature to \(newValue)")
            privateTemperature = newValue
        }
        get {
            print("get temperature")
            return privateTemperature
        }
    }
    
    dynamic var isOn = true
    
    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func makeWarmer(sender: NSButton) {
        temperature++
    }
    
    @IBAction func makeCooler(sender: NSButton) {
        temperature--
    }
}
