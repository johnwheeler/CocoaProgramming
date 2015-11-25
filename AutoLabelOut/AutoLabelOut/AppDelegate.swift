//
//  AppDelegate.swift
//  AutoLabelOut
//
//  Created by John Wheeler on 11/24/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create the controls for the window
        
        // Create a label:
        let label = NSTextField(frame: NSRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.stringValue = "Label"
        // Give this NSTextField the styling of a label
        label.backgroundColor = NSColor.clearColor()
        label.editable = false
        label.selectable = false
        label.bezeled = false
        
        // Create a text field:
        let textField = NSTextField(frame: NSRect.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Make the text field update the label's text
        textField.action = Selector("tabkeStringValueFrom:")
        textField.target = label
        
        let superview = window.contentView as NSView!
        superview.addSubview(label)
        superview.addSubview(textField)
        
        // Create the constraints between the controls
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[label]-[textField(>=100)]-|",
            options: .AlignAllBaseline,
            metrics: nil,
            views: ["label": label, "textField": textField])
        NSLayoutConstraint.activateConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[textField]-|",
            options: [],
            metrics: nil,
            views: ["textField": textField])
        NSLayoutConstraint.activateConstraints(verticalConstraints)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

