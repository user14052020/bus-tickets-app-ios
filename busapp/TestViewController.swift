//
//  TestViewController.swift
//  busapp
//
//  Created by Андрей on 23/05/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit
import SafariServices

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let SafariVC = SFSafariViewController.init(url: URL(string: "https://easyway24.ru")!);
        // Do any additional setup after loading the view.
        self.present(SafariVC, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
