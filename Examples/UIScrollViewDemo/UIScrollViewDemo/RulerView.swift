//
//  RulerView.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

private let itemWidth: CGFloat = 80
private let padding: CGFloat = 10

class RulerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        layout.minimumLineSpacing = padding
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        let margin = (self.frame.width - itemWidth) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        collectionView.backgroundColor = UIColor.green
        return collectionView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: CGRect(x: self.frame.width / 2 - 40, y: 20, width: 80, height: 2))
        textLabel.backgroundColor = UIColor.red
        return textLabel
    }()

    private lazy var verticalLine: CALayer = {
        let verticalLine = CALayer()
        verticalLine.frame = CGRect(x: (self.frame.width - 1) / 2, y: 0, width: 1, height: self.frame.height)
        verticalLine.backgroundColor = UIColor.red.cgColor
        return verticalLine
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(MootsCollectionCell.self, forCellWithReuseIdentifier: "cellID")
        addSubview(textLabel)
        layer.addSublayer(verticalLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = UIColor.gray
        return cell
    }

    func nearestTargetOffset(for offset: CGPoint) -> CGPoint {
        let pageSize = padding + itemWidth
        let page = roundf(Float(offset.x / pageSize))
        let targetX = pageSize * CGFloat(page)
        let margin = (self.frame.width - itemWidth) / 2
        return CGPoint(x: targetX - margin, y: offset.y)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = nearestTargetOffset(for: targetContentOffset.pointee)
        targetContentOffset.pointee.x = targetOffset.x
        targetContentOffset.pointee.y = targetOffset.y
    }
}
