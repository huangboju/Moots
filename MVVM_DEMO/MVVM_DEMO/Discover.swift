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
        case Default = 1
        case Special = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.registerClass(DiscoverCell.self, forCellReuseIdentifier: "discoverCell")
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath) as! DiscoverCell
        let discoverModel = DiscoverViewModel()
        cell.configure(withDataSource: discoverModel, delegate: discoverModel)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
