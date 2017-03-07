//
//  StaticPageController.swift
//  Yo365
//
//  Created by Billy on 3/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import UIKit
import WebKit

class StaticPageController: BaseNavController, UIWebViewDelegate{
    @IBOutlet var webView: UIWebView!
    
    var staticTitle: String?
    var staticPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTitleHeader(title: staticTitle!)
        
        let url = URL.init(string: staticPath!)
        let request = URLRequest.init(url: url!)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
