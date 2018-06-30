//
//  TableViewSelfsizing.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit
import SnapKit

struct Item {
    let text: String
    var flag: Bool
}

class TableViewSelfsizing: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.register(TableViewSelfsizingCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    lazy var data: [[Item]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        for _ in 0 ..< 10 {
            if data.isEmpty {
                data.append([Item(text: "这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：", flag: false)])
            } else {
                data[0].append(Item(text: "这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：这个特性首先要求是 iOS8，要是最低支持的系统版本小于8的话，还得针对老版本单写套老式的算高（囧），不过用的 API 到不是新面孔：", flag: false))
            }
        }

        view.addSubview(tableView)
    }
}

extension TableViewSelfsizing: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.section][indexPath.row]
        (cell as? TableViewSelfsizingCell)?.content = item.text
        (cell as? TableViewSelfsizingCell)?.isExpanding = item.flag
        return cell
    }
}

extension TableViewSelfsizing: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = data[indexPath.section][indexPath.row]
        item.flag = !item.flag
        data[indexPath.section][indexPath.row] = item
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewSelfsizingCell else { return }
        cell.isExpanding = item.flag
        
        // 4
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // 5
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

class TableViewSelfsizingCell: UITableViewCell {
    
    private let myLabel = UILabel()

    var constraint: Constraint!
    
    var content: String? {
        didSet {
            myLabel.text = content
        }
    }
    
    var isExpanding = false {
        didSet {
            if isExpanding {
                constraint.deactivate()
                myLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(30)
                    make.bottom.equalTo(-30)
                })
            } else {
                constraint.activate()
                myLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(8)
                    make.bottom.equalTo(-8)
                })
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myLabel)
        myLabel.numberOfLines = 0
        myLabel.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(16)
            make.trailingMargin.equalTo(-16)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            constraint = make.height.equalTo(80).priority(999).constraint
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
