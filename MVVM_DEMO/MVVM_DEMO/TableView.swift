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
        case minionMode
        // other settings here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCellId")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let setting = Setting(rawValue: (indexPath as NSIndexPath).row) {
            switch setting {
            case .minionMode:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCellId", for: indexPath) as? SwitchCell
                
                // this is where the magic happens!
                let viewModel = Model()
                cell?.configure(withDataSource: viewModel, delegate: viewModel)
                return cell ?? SwitchCell()
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
