//
//  PopoverViewController.swift
//  Popover
//
//  Created by iosci on 2016/10/9.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 600, height: 300)
        
//        let tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "123")
//        self.tableView = tableView
//        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.tableView?.frame = self.view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "123", for: indexPath)
        cell.textLabel?.text = "11111"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
