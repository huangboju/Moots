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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
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
        "HTML"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableNestCollectionController"
        view.addSubview(tableView)
    }
}

extension TableNestCollectionController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell as? TableNestCollectionCell)?.data = data
        return cell
    }
}

class TableNestCollectionCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = CGSize(width: 100, height: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "tagCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var dummyView: UIView = {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(dummyView)

        dummyView.addSubview(collectionView)

        dummyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        dummyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        dummyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true

        collectionView.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: dummyView.trailingAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var data: [String] = [] {
        didSet {
            collectionView.reloadData()
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
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        textLabel.textAlignment = .center
        return textLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)

        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
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
