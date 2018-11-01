//
//  ConfigController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 7/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//
import UIKit
import AKPFlowLayout

/// Visual configuration of AKPCollectionViewFlowLayout's LayoutConfigOptions 

class LayoutConfigController: UITableViewController {
    var configOptions: AKPLayoutConfigOptions?
    var selectedOptions: AKPLayoutConfigOptions?

    var height: CGFloat {
        let numRows = tableView(tableView, numberOfRowsInSection: 0)
        let headerHeight = tableView(tableView, heightForHeaderInSection: 0)
        let footerHeight = tableView(tableView, heightForFooterInSection: 0)
        
        return CGFloat(numRows) * tableView.rowHeight + CGFloat(headerHeight + footerHeight)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellReuseID")
    }
    
    override func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return configOptions?.descriptions.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseID",
                                                 for: indexPath) as UITableViewCell
        if let configOptions = configOptions
                                    , configOptions.descriptions.count > indexPath.row {
            let optionDescription = configOptions.descriptions[indexPath.row]
            cell.textLabel?.text = optionDescription
            if let selectedOptions = selectedOptions {
                let option = AKPLayoutConfigOptions(rawValue: 1 << indexPath.row)
                cell.accessoryType = selectedOptions.contains(option) ?
                    UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            }
        }
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedOptions = selectedOptions {
            let option = AKPLayoutConfigOptions(rawValue: 1 << indexPath.row )
            if selectedOptions.contains(option) {
                _ = self.selectedOptions?.remove(option)
            } else {
                self.selectedOptions?.insert(option)
            }
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
