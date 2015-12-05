//
//  WebViewController.swift
//  RanchForecastSplit
//
//  Created by John Wheeler on 12/5/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController {
    
    var webView: WKWebView {
        return view as! WKWebView
    }
    
    override func loadView() {
        let webView = WKWebView()
        view = webView
    }

    func loadURL(url: NSURL) {
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}
