//
//  SecondViewController.swift
//  Popover
//
//  Created by iosci on 2016/10/11.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    @IBAction func _dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
 
}
