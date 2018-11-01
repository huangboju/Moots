//
//  TableViewNestCollectionview.swift
//  UICollectionViewDemo
//
//  Created by 黄伯驹 on 2017/12/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TableNestCollectionController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(TableNestCollectionCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    var data = [
        "C++",
        "C",
        "Objective-C",
        "Javascript",
        "CSS",
        "Swift",
        "Go",
        "Python",
        "PHP",
        "HTML",
        "Objective-C",
        "Javascript",
        "CSS",
        "Swift",
        "PHP",
        "HTML",
        "Objective-C",
        "Javascript",
        "CSS",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableNestCollectionController"
        view.addSubview(tableView)
    }
}

extension TableNestCollectionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell as? TableNestCollectionCell)?.data = data
        return cell
    }
}

class TableNestCollectionCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.itemSize = CGSize(width: 51, height: 51)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "tagCell")
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var dummyView: UIView = {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }()
    
    private let headerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(headerView)
        headerView.backgroundColor = .red
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }

        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(10)
            make.bottom.equalTo(-10).priority(999)
            make.height.equalTo(100)
        }

        dummyView.backgroundColor = .gray

        dummyView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
//        dummyView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
//        dummyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
//        dummyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
//        dummyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
//
//        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: dummyView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: [String] = [] {
        didSet {
            collectionView.reloadData()

            // http://www.cocoachina.com/bbs/read.php?tid=111832
            collectionView.layoutIfNeeded()
            
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            dummyView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
//            let heightAnchor = dummyView.heightAnchor.constraint(equalToConstant: height)
//            heightAnchor.priority = UILayoutPriority(999)
//            heightAnchor.isActive = true
        }
    }
}

extension TableNestCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        cell.backgroundColor = UIColor(red: 100 / 255, green: 149 / 255, blue: 237 / 255, alpha: 1)
        (cell as? TagCell)?.text = data[indexPath.row]
        return cell
    }
}

class TagCell: UICollectionViewCell {
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        
        textLabel.snp.makeConstraints { (make) in
            make.top.leading.equalTo(8)
            make.center.equalTo(self).priority(999)
        }
        
//        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
//        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
//        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

