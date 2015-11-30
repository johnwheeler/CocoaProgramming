//
//  ImageViewController.swift
//  ViewControl
//
//  Created by John Wheeler on 11/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController, ImageRepresentable {
    
    var image: NSImage?
    
    override var nibName: String {
        return "ImageViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
