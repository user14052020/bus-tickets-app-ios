//
//  HelpViewController.swift
//  busapp
//
//  Created by Андрей on 23/05/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://easyway24.ru/help?mode=app&nobar=true")
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.scrollView.bounces = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if ["tel", "mailto"].contains(navigationAction.request.url?.scheme) {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
