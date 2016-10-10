//
//  ViewController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/10.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
    }
    
        func handleLogout(){
            let loginController = LoginController()
            presentViewController(loginController, animated: true, completion: nil)
        }

}

