//
//  TableView.swift
//  MVVM_DEMO
//
//  Created by 伯驹 黄 on 16/5/23.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class TableView: UITableViewController {
    
    enum Setting: Int {
        case MinionMode
        // other settings here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.registerClass(SwitchCell.self, forCellReuseIdentifier: "SwitchCellId")
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let setting = Setting(rawValue: indexPath.row) {
            switch setting {
            case .MinionMode:
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCellId", forIndexPath: indexPath) as? SwitchCell
                
                // this is where the magic happens!
                let viewModel = Model()
                cell?.configure(withDataSource: viewModel, delegate: viewModel)
                return cell ?? SwitchCell()
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
