//
//  MainWindowController.swift
//  RGBWell
//
//  Created by John Wheeler on 10/28/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    let a = 1.0
    
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    
    override var windowNibName: String?  {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        rSlider.doubleValue = r
        bSlider.doubleValue = b
        gSlider.doubleValue = g
        updateColor()
    }
    
    @IBAction func adjustRed(sender: NSSlider) {
        print("R slider's value is \(sender.floatValue)")
        r = sender.doubleValue
        updateColor()
    }

    @IBAction func adjustGreen(sender: NSSlider) {
        print("G slider's value is \(sender.floatValue)")
        g = sender.doubleValue
        updateColor()
    }

    @IBAction func adjustBlue(sender: NSSlider) {
        print("B slider's value is \(sender.floatValue)")
        b = sender.doubleValue
        updateColor()
    }
    
    func updateColor() {
        let newColor = NSColor(calibratedRed: CGFloat(r),
            green: CGFloat(g),
            blue: CGFloat(b),
            alpha: CGFloat(a))
        colorWell.color = newColor
    }
}
