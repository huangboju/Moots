//
//  TagsController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 08/02/2018.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class TagsHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .groupTableViewBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TagsController: UIViewController {
    
    var data = [
        [
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
            "CSS"
        ],
        [
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
            "CSS"
        ],
        [
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
            "CSS"
        ],
        [
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
            "CSS"
        ]
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        // ios10 以下用这个会crash
//        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.itemSize = CGSize(width: 51, height: 51)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 35)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "tagCell")
        collectionView.register(TagsHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension TagsController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        cell.backgroundColor = UIColor(red: 100 / 255, green: 149 / 255, blue: 237 / 255, alpha: 1)
        (cell as? TagCell)?.text = data[indexPath.section][indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        }
        return UICollectionReusableView()
    }
}
