//
//  Document.swift
//  ZIPspector
//
//  Created by John Wheeler on 12/9/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var filenames: [String] = []

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        return "Document"
    }
    
    override func readFromURL(url: NSURL, ofType typeName: String) throws {
        // Which filename are we getting the zipinfo for?
        let filename = url.path!
        
        // Prepare a task object
        let task = NSTask()
        task.launchPath = "/usr/bin/zipinfo"
        task.arguments = ["-1", filename]
        
        // Create the pipe to read from
        let outPipe = NSPipe()
        task.standardOutput = outPipe
        
        // Start the process
        task.launch()
        
        // Read the output
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        
        // Make sure the task terminates normally
        task.waitUntilExit()
        let status = task.terminationStatus
        
        // Check status
        if status != 0 {
            let errorDomain = "com.bignerdranch.ProcessReturnErrorCodeDomain"
            let errorInfo = [ NSLocalizedFailureReasonErrorKey : "zipinfo returned \(status)" ]
            let error = NSError(domain: errorDomain, code: 0, userInfo: errorInfo)
            throw error
        }
        
        let string = NSString(data: data, encoding:  NSUTF8StringEncoding)!
        
        // Break the string into lines
        filenames = string.componentsSeparatedByString("\n")
        print("filesnames = \(filenames)")
        
        // In case of revert
        tableView?.reloadData()
    }
    
    // MARK: - NSTableViewDataSource


    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return filenames.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return filenames[row]
    }
}

