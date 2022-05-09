//
//  ViewController.swift
//  RunTime
//
//  Created by 伯驹 黄 on 2016/10/19.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class TableViewFooterSelfSizing: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            FriendTableViewController.self,
            PagingEnabled.self,
            InfiniteScrollViewController.self,
            ScrollViewController.self
        ],
        [
            SignInController.self
        ]
    ]
    
    let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CycleViewController"

        view.addSubview(tableView)
        
        let footerView = UIView()
        footerView.backgroundColor = .red
        tableView.tableFooterView = footerView

        textLabel.text = "作为开发人员，理解HTTPS的原理和应用算是一项基本技能。HTTPS目前来说是非常安全的，但仍然有大量的公司还在使用HTTP。其实HTTPS也并不是很贵啊。"
        textLabel.numberOfLines = 0

        footerView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.width.equalTo(tableView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeFooterToFit()
    }
}

extension TableViewFooterSelfSizing: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension TableViewFooterSelfSizing: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textLabel.text! += "在网上可以找到大把的介绍HTTTPS的文章，在阅读ServerTrustPolicy.swfit代码前，我们先简单的讲一下HTTPS请求的过程："
    }
}

