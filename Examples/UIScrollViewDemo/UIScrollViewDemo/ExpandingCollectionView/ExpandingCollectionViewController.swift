//
//  ExpandingCollectionViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ExpandingCollectionViewController: UIViewController {
    
    fileprivate lazy var items: [String] = []
    
    private lazy var collectionView: UICollectionView = {
        var rect = self.view.frame
        let layout = UltravisualLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        for _ in 0 ..< 10 {
            items.append("I'm trying to get self sizing UICollectionViewCells working with Auto Layout, but I can't seem to get the cells to size themselves to the content. I'm having trouble understanding how the cell's size is updated from the contents of what's inside the cell's contentView.")
        }
        
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ExpandingCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell as? MyCell)?.text = items[indexPath.row]
        return cell
    }
}

extension ExpandingCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionView.collectionViewLayout as! UltravisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
}
