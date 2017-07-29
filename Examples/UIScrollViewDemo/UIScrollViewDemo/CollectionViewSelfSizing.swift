//
//  CollectionViewSelfSizing.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CollectionViewSelfSizing: UIViewController {
    
    fileprivate lazy var items: [String] = []
    
    private lazy var collectionView: UICollectionView = {
        var rect = self.view.frame
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue

        for _ in 0 ..< 10 {
            items.append("I'm trying to get self sizing UICollectionViewCells working with Auto Layout, but I can't seem to get the cells to size themselves to the content. I'm having trouble understanding how the cell's size is updated from the contents of what's inside the cell's contentView.")
        }

        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CollectionViewSelfSizing: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell as? MyCell)?.text = items[indexPath.row]
        return cell
    }
}

class MyCell: UICollectionViewCell {
    let textLabel = UILabel()
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.8, alpha: 1)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }

        contentView.addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(8)
            make.right.bottom.equalTo(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
