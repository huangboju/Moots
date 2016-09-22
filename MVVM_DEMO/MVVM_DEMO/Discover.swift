//
//  Discover.swift
//  MVVM_DEMO
//
//  Created by 伯驹 黄 on 16/5/23.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class Discover: UITableViewController {

    enum CellType: Int {
        case `default` = 1
        case special = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(DiscoverCell.self, forCellReuseIdentifier: "discoverCell")
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let type = CellType(rawValue: indexPath.row) {
//            switch type {
//            case .Default:
//                return tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
//            default:
//                let cell = tableView.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath) as! DiscoverCell
//                let discoverModel = DiscoverViewModel()
//                cell.configure(withDataSource: discoverModel, delegate: discoverModel)
//                return cell
//            }
//        }
//        return tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverCell
        let discoverModel = DiscoverViewModel()
        cell.configure(withDataSource: discoverModel, delegate: discoverModel)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
