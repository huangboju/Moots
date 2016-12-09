//
//  ViewController.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2016/11/28.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class IconLabelController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        var rect = self.view.frame

        let layout = UICollectionViewFlowLayout()
        let width = layout.fixSlit(rect: &rect, colCount: 2, space: 1)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: rect.width, height: 180)
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue

        collectionView.register(IconLabelCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)

        var x: CGFloat = 0

        for i in 0..<4 {
            let iconLabel = IconLabel()
            iconLabel.direction = IconDirection(rawValue: i)!
            iconLabel.edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            iconLabel.set("知乎", with: UIImage(named: "icon"))
            iconLabel.frame.origin = CGPoint(x: x, y: 20)
            x = iconLabel.frame.maxX + 20
            collectionView.addSubview(iconLabel)
        }
    }

    let directions: [NSLayoutAttribute] = [
        .top,
        .bottom,
        .left,
        .right
    ]

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IconLabelController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

extension IconLabelController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? IconLabelCell)?.direction = directions[indexPath.row % 4]
        cell.backgroundColor = UIColor.groupTableViewBackground
    }
}

