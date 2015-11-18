//
//  DieView.swift
//  Dice
//
//  Created by John Wheeler on 11/12/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class DieView: NSView {
    
    var intValue: Int? = 5 {
        didSet {
            needsDisplay = true
        }
    }
    
    var pressed: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    var highlighted: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    func randomize() {
        intValue = Int(arc4random_uniform(6)) + 1
    }
    
    @IBAction func savePDF(sender: AnyObject) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.beginSheetModalForWindow(window!) {
            [unowned savePanel] (result) in
            if result == NSModalResponseOK {
                let data = self.dataWithPDFInsideRect(self.bounds)
                let ok = data.writeToURL(savePanel.URL!, atomically: true)
                if !ok {
                    let alert = NSAlert()
                    alert.informativeText = "Error saving PDF"
                    alert.runModal()
                }
            }
        }
    }
    
    override func viewDidMoveToWindow() {
        window?.acceptsMouseMovedEvents = true
        
        let options: NSTrackingAreaOptions = [.MouseEnteredAndExited, .ActiveAlways, .InVisibleRect]
        
        let trackingArea = NSTrackingArea(rect: NSRect(),
            options: options,
            owner: self,
            userInfo: nil)
        
        addTrackingArea(trackingArea)
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 20, height: 20)
    }

    override func drawRect(dirtyRect: NSRect) {
        let backgroundColor = NSColor.lightGrayColor()
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)
        
//        // Chap 19 x-tra credit - rollovers
//        if (highlighted) {
//            let highlightColor = NSColor.controlHighlightColor()
//            highlightColor.set()
//            NSBezierPath.fillRect(bounds)
//        }
        
        drawDieWithSize(bounds.size)
    }
    
    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength / 10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
        var dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
        if pressed {
            dieFrame = dieFrame.offsetBy(dx: 0, dy: -edgeLength / 40)
        }
        return (edgeLength, dieFrame)
    }
    
    func drawDieWithSize(size: CGSize) {
        if let intValue = intValue {
            let (edgeLength, dieFrame) = metricsForSize(size)
            let cornerRadius: CGFloat = edgeLength / 5.0
            
            let dotRadius = edgeLength / 12.0
            let dotFrame = dieFrame.insetBy(dx: dotRadius * 2.5, dy: dotRadius * 2.5)
            
            NSGraphicsContext.saveGraphicsState()
            
            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            shadow.shadowBlurRadius = (pressed ? edgeLength / 100 : edgeLength / 20)
            shadow.set()
            
            // Draw the rounded shape of the die profile
            NSColor.whiteColor().set()
            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
            
            NSGraphicsContext.restoreGraphicsState()
            // Shadow will not apply to subsequent drawing commands
            
            // Draw dots
            NSColor.blackColor().set()
            
            // Nested function to make drawing dots cleaner
            func drawDot(u: CGFloat, v: CGFloat) {
                let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u,
                    y: dotFrame.minY + dotFrame.height * v)
                let dotRect = CGRect(origin: dotOrigin, size: CGSizeZero)
                    .insetBy(dx: -dotRadius, dy: -dotRadius)
                NSBezierPath(ovalInRect: dotRect).fill()
            }
            
            if (1...6).indexOf(intValue) != nil {
                if [1, 3, 5].indexOf(intValue) != nil {
                    drawDot(0.5, v: 0.5) // Center dot
                }
                if (2...6).indexOf(intValue) != nil {
                    drawDot(0, v: 1) // Upper left
                    drawDot(1, v: 0) // Lower right
                }
                if (4...6).indexOf(intValue) != nil {
                    drawDot(1, v: 1) // Upper right
                    drawDot(0, v: 0) // Lower legt
                }
                if intValue == 6 {
                    drawDot(0, v: 0.5) // Mid left/right
                    drawDot(1, v: 0.5)
                }
            } else {
                let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
                paraStyle.alignment = .Center
                let font = NSFont.systemFontOfSize(edgeLength * 0.5)
                let attrs = [
                    NSForegroundColorAttributeName: NSColor.blackColor(),
                    NSFontAttributeName: font,
                    NSParagraphStyleAttributeName: paraStyle
                ]
                let string = "\(intValue)"
                string.drawCenteredInRect(dieFrame, attributes: attrs)
            }
        }
    }
    
    // MARK: - Mouse Events
    
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("mouseDown")
        let dieFrame = metricsForSize(bounds.size).dieFrame
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        pressed = dieFrame.contains(pointInView)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        Swift.print("mouseDragged \(theEvent.locationInWindow)")
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Swift.print("mouseUp clickCount: \(theEvent.clickCount)")
        if theEvent.clickCount == 2 && pressed {
            randomize()
        }
        pressed = false
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        highlighted = true
    }
    
    override func mouseExited(theEvent: NSEvent) {
        highlighted = false
    }
    
    // MARK: - First Responder
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func drawFocusRingMask() {
        NSBezierPath.fillRect(bounds)
    }
    
    override var focusRingMaskBounds: NSRect {
        return bounds
    }
    
    // MARK: - Keyboard Events
    
    override func keyDown(theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }
    
    override func insertText(insertString: AnyObject) {
        let text = insertString as! String
        if let number = Int(text) {
            intValue = number
        }
    }
    
    override func insertTab(sender: AnyObject?) {
        window?.selectNextKeyView(sender)
    }
    
    override func insertBacktab(sender: AnyObject?) {
        window?.selectPreviousKeyView(sender)
    }
}








