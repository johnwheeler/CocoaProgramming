//
//  Document.swift
//  RaiseMan
//
//  Created by John Wheeler on 10/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private var KVOContext: Int = 0

class Document: NSDocument, NSWindowDelegate {
    
    @IBOutlet weak var tableView: NSTableView!    
    @IBOutlet weak var arrayController: NSArrayController!
    
    var employees: [Employee] = [] {
        willSet {
            for employee in employees {
                stopObservingEmployee(employee)
            }
        }
        didSet {
            for employee in employees {
                startObservingEmployee(employee)
            }
        }
    }

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        return "Document"
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // End editing
        tableView.window?.endEditingFor(nil)
        
        // Create an NSData object from the employees array
        return NSKeyedArchiver.archivedDataWithRootObject(employees)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        print("About to read data of type \(typeName).")
        
        employees = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Employee]
    }
    
    override func printOperationWithSettings(printSettings: [String : AnyObject]) throws -> NSPrintOperation {
        let employeesPrintView = EmployeesPrintingView(employees: employees)
        let printInfo: NSPrintInfo = self.printInfo
        let printOperation = NSPrintOperation(view: employeesPrintView, printInfo: printInfo)
        
        return printOperation
    }
    
    // MARK: - Accessors
    
    func insertObject(employee: Employee, inEmployeesAtIndex index: Int) {
        print("adding \(employee) to the employees array")
        
        // Add the inverse of the operation to the undo stack
        let undo: NSUndoManager = undoManager!
        undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(employees.count)
        if !undo.undoing {
            undo.setActionName("Add Person")
        }
        
        employees.append(employee)
    }
    
    func removeObjectFromEmployeesAtIndex(index: Int) {
        let employee = employees[index]
        
        print("removing \(employee) from the employees array")
        let undo: NSUndoManager = undoManager!
        undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)
        if !undo.undoing {
            undo.setActionName("Remove Person")
        }
        
        // Remove the Employee from the array
        employees.removeAtIndex(index)
    }
    
    // MARK: - Key Value Observing
    
    func startObservingEmployee(employee: Employee) {
        employee.addObserver(self, forKeyPath: "name", options: .Old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .Old, context: &KVOContext)
    }
    
    func stopObservingEmployee(employee: Employee) {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context != &KVOContext {
            // If the context does not match, this message must be intended for our superclass
            // JMW Note - The book says this check isn't necessary since Document.swift simply
            // inherits from NSDocument, but this 'defensive' style of coding should be the default
            // way to do things.
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        var oldValue: AnyObject? = change![NSKeyValueChangeOldKey]
        if oldValue is NSNull {
            oldValue = nil
        }
        
        let undo: NSUndoManager = undoManager!
        print("oldValue=\(oldValue)")
        undo.prepareWithInvocationTarget(object!).setValue(oldValue, forKeyPath: keyPath!)
    }
    
    // MARK: - Action NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        // trigger employees willSet to stop observing. didSet will not have any employees to observe
        employees = []
    }
    
    // MARK - Actions
    
    @IBAction func addEmployee(sender: NSButton) {
        let windowController = windowControllers[0]
        let window = windowController.window!
        
        let endedEditing = window.makeFirstResponder(window)
        if !endedEditing {
            print("Unable to end editing")
            return
        }
        
        let undo: NSUndoManager = undoManager!
        
        // Has an edit occurred already in this event?
        if undo.groupingLevel > 0 {
            // Close the last group
            undo.endUndoGrouping()
            // Open a new group
            undo.beginUndoGrouping()
        }
        
        // Create the object
        let employee = arrayController.newObject() as! Employee
        
        // Add it to the array controller's contentArray
        arrayController.addObject(employee)
        
        // Re-sort (in case the user has sorted a column)
        arrayController.rearrangeObjects()
        
        // Get the sorted array
        let sortedEmployees = arrayController.arrangedObjects as! [Employee]
        
        // Find the object just added
        let row = sortedEmployees.indexOf(employee)!
        
        // Begin the edit in the first column
        print("starting edit of \(employee) in row \(row)")
        tableView.editColumn(0, row: row, withEvent: nil, select: true)
    }
    
    @IBAction func removeEmployee(sender: NSButton) {
        let selectedPeople = arrayController.selectedObjects as! [Employee]
        
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("REMOVE_MESSAGE", comment: "The remove alert's messageText")
        
        let informativeFormat = NSLocalizedString("REMOVE_INFORMATIVE %d", comment: "The remove alert's informativeText")
        alert.informativeText = String(format: informativeFormat, selectedPeople.count)
        
        let removeButtonTitle = NSLocalizedString("REMOVE_DO", comment: "The remove alert's remove button")
        alert.addButtonWithTitle(removeButtonTitle)
        
        let removeCancelTitle = NSLocalizedString("REMOVE_CANCEL", comment: "The remove alert's cancel button")
        alert.addButtonWithTitle(removeCancelTitle)
        
        let removeKeepNoRaiseTitle = NSLocalizedString("REMOVE_KEEP_NO_RAISE", comment: "The remove alert's keep but no raise button")
        alert.addButtonWithTitle(removeKeepNoRaiseTitle)
        
        let window = sender.window!
        alert.beginSheetModalForWindow(window) { (response) -> Void in
            // If the user chose "Remove" tell the array controller to delete the people
            switch response {
            case NSAlertFirstButtonReturn:
                // The array controller will delete the selected objects
                // The argument to remove() is ignored
                self.arrayController.remove(nil)
            case NSAlertThirdButtonReturn:
                for employee in selectedPeople {
                    employee.setValue(0, forKeyPath: "raise")
                }
            default: break
            }
        }
    }
}







