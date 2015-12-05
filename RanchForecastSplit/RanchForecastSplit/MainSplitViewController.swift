//
//  MainSplitViewController.swift
//  RanchForecastSplit
//
//  Created by John Wheeler on 12/5/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController, CourseListViewControllerDelegate {
    
    var masterViewController: CourseListViewController {
        let masterItem = splitViewItems[0]
        return masterItem.viewController as! CourseListViewController
    }
    
    var detailViewController: WebViewController {
        let detailItem = splitViewItems[1]
        return detailItem.viewController as! WebViewController
    }
    
    let defaultURL = NSURL(string: "http://www.bignerdranch.com/")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterViewController.delegate = self
        detailViewController.loadURL(defaultURL)
    }
    
    // MARK: CourseListViewControllerDelegate
    
    func courseListViewController(viewController: CourseListViewController, selectedCourse: Course?) {
        if let course = selectedCourse {
            print(course.url)
            detailViewController.loadURL(course.url)
        } else {
            detailViewController.loadURL(defaultURL)
        }
    }
}
