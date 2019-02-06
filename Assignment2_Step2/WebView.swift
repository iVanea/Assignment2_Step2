//
//  WebView.swift
//  Assignment2_Step2
//
//  Created by Timotin Ion on 2/4/19.
//  Copyright © 2019 Timotin. All rights reserved.
//

import UIKit
import WebKit

class WebView : WKWebView {
    
    init(){
        let webConfig:WKWebViewConfiguration = WKWebViewConfiguration()
        super.init(frame:.zero,configuration:webConfig)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.allowsBackForwardNavigationGestures = true
        createHomePage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -100)
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item:self,attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60)
        view.addConstraints([height, width, top])
    }
    
    func setUrl(url:String!) {
        if url != nil {
            let url = NSURL(string:url)
            let request = NSURLRequest(url:url! as URL)
            self.load(request as URLRequest)
        }
    }
    
    func createHomePage() {
        self.setUrl(url: "about:blank")
        drawHomePage()
    }
    

    func drawHomePage() {
        let javaSCriptString="document.body.style.background=\"#ffc\""
        //self.loadHTMLString("<h1>Top20</h1>", baseURL: nil)
        self.evaluateJavaScript(javaSCriptString, completionHandler: nil)
    }
    
    func setAppHome() {
        print("The first item is \(String(describing: self.findFirstItem()?.url))")
        let item = findFirstItem()
        if item != nil {
            self.go(to: item!)
            drawHomePage()
        }
    }
    
  
    func findFirstItem() -> WKBackForwardListItem? {
        var index=0
        if (self.backForwardList.item(at: 0)==nil) {
            return nil
        }
        while self.backForwardList.item(at: index) != nil {
            index = index-1
        }
        return self.backForwardList.item(at: index+1)
    }
    
    func forward() {
        if self.canGoForward {
            self.goForward()
        } else {
            print("Cannot go forward.")
        }
    }
    
 
    func back(){
        if self.canGoBack {
            self.goBack()
        } else {
            print("Cannot go backwards.")
        }
    }
    
}
