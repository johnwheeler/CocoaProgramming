//
//  ScheduleFetcher.swift
//  RanchForcast
//
//  Created by John Wheeler on 11/28/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class ScheduleFetcher {
    
    enum FetchCoursesResult {
        case Success([Course])
        case Failure(NSError)
    }
    
    let session: NSURLSession
    
    init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    func fetchCoursesUsingCompletionHandler(completionHandler: (FetchCoursesResult) -> (Void)) {
        let url = NSURL(string: "https://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            var result: FetchCoursesResult
            
            if data == nil {
                result = .Failure(error!)
            } else if let response = response as? NSHTTPURLResponse {
                print("\(data!.length) bytes, HTTP \(response.statusCode).")
                if response.statusCode == 200 {
                    result = self.resultFromData(data!)
                } else {
                    let error = self.errorWithCode(1, localizedDescription: "Bad status code \(response.statusCode)")
                    result = .Failure(error)
                }
            } else {
                let error = self.errorWithCode(1, localizedDescription: "Unexpected response object.")
                result = .Failure(error)
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completionHandler(result)
            })
        }
        task.resume()
    }
    
    func errorWithCode(code: Int, localizedDescription: String) -> NSError {
        return NSError(domain: "ScheduleFetcher", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    func resultFromData(data: NSData) -> FetchCoursesResult {
        do {
            let topLevelDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            let courseDicts = topLevelDict["courses"] as! [NSDictionary]
            var courses: [Course] = []
            for courseDict in courseDicts {
                if let course = courseFromDictionary(courseDict) {
                    courses.append(course)
                }
            }
            return .Success(courses)
        } catch {
            return .Failure(error as NSError)
        }
    }
    
    func courseFromDictionary(courseDict: NSDictionary) -> Course? {
        if let title = courseDict["title"] as? String,
            let urlString = courseDict["url"] as? String,
            let upcomingArray = courseDict["upcoming"] as? [NSDictionary],
            let nextUpcomingDict = upcomingArray.first,
            let nextStartingDateString = nextUpcomingDict["start_date"] as? String {
                let url = NSURL(string: urlString)!
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let nextStartDate = dateFormatter.dateFromString(nextStartingDateString)!
                
                return Course(title: title, url: url, nextStartDate: nextStartDate)
        } else {
            return nil
        }
        
    }
}