//
//  NerdTabViewController.swift
//  ViewControl
//
//  Created by John Wheeler on 11/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class NerdTabViewController: NSViewController {
    
    var box = NSBox()
    var buttons: [NSButton] = []
    
    func selectTabAtIndex(index: Int) {
        assert((0..<childViewControllers.count).contains(index), "index out of range")
        for (i, button) in buttons.enumerate() {
            button.state = (index == i) ? NSOnState : NSOffState
        }
        let viewController = childViewControllers[index]
        box.contentView = viewController.view
    }
    
    func selectTab(sender: NSButton) {
        let index = sender.tag
        selectTabAtIndex(index)
    }

    override func loadView() {
        view = NSView()
        reset()
    }
    
    func tryPrint(f: CGFloat) {
        Swift.print(f)
    }
    
    func reset() {
        view.subviews = []
        
        let buttonWidth:CGFloat = 28.0
        let buttonHeight:CGFloat = 28.0
        
        buttons = childViewControllers.enumerate().map {
            (index, viewController) -> NSButton in
            let button = NSButton()
            button.setButtonType(.ToggleButton)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.bordered = false
            button.target = self
            button.action = Selector("selectTab:")
            button.tag = index
            if let viewController = viewController as? ImageRepresentable {
                button.image = viewController.image
            } else {
                button.title = viewController.title!
            }
            
            button.addConstraints([
                NSLayoutConstraint(item: button,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1.0,
                    constant: buttonWidth),
                NSLayoutConstraint(item: button,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1.0,
                    constant: buttonHeight
                )])
            return button
        }
        
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .Horizontal
        stackView.spacing = 4
        for button in buttons {
            stackView.addView(button, inGravity: .Center)
        }
        
        box.translatesAutoresizingMaskIntoConstraints = false
        box.borderType = .NoBorder
        box.boxType = .Custom
        
        let separator = NSBox()
        separator.boxType = .Separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        view.subviews = [stackView, separator, box]
        
        let views = ["stack": stackView, "separator": separator, "box": box]
        let metrics = ["buttonHeight": buttonHeight]
        
        func addVisualFormatConstraints(visualFormat: String) {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
                options: [],
                metrics: metrics,
                views: views))
        }
        
        addVisualFormatConstraints("H:|[stack]|")
        addVisualFormatConstraints("H:|[separator]|")
        addVisualFormatConstraints("H:|[box(>=100)]|")
        addVisualFormatConstraints("V:|[stack(buttonHeight)][separator(==1)][box(>=100)]|")
        
        if childViewControllers.count > 0 {
            selectTabAtIndex(0)
        }
    }
    
    override func insertChildViewController(childViewController: NSViewController, atIndex index: Int) {
        super.insertChildViewController(childViewController, atIndex: index)
        if viewLoaded {
            reset()
        }
    }
    
    override func removeChildViewControllerAtIndex(index: Int) {
        super.removeChildViewControllerAtIndex(index)
        if viewLoaded {
            reset()
        }
    }
    
}
