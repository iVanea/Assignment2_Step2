//
//  PageViewController.swift
//  Assignment2_Step2
//
//  Created by Timotin Ion on 2/5/19.
//  Copyright © 2019 Timotin. All rights reserved.
//

import UIKit
import WebKit

class PageViewController: UIViewController {
    
    var webView: WebView
    var url = ""
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WebView()
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.setPosition(view: view)
        webView.setUrl(url: url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
