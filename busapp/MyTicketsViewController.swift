//
//  MyTicketsViewController.swift
//  busapp
//
//  Created by Андрей on 23/05/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit
import WebKit

class MyTicketsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://easyway24.ru/lk?mode=app&nobar=true")
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.scrollView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.reload();
    }


}
