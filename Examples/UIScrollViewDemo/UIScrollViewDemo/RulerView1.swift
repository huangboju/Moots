//
//  RulerView1.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

func flat(_ value: CGFloat) -> CGFloat {
    let s = UIScreen.main.scale
    return ceil(value * s) / s
}

let goldenRatio: CGFloat = 0.618

private let reulerViewHeight: CGFloat = 132

private let bottomLineMinY = (reulerViewHeight + itemHeight + titleSpace) / 2

private let itemWidth: CGFloat = 16
private let itemHeight: CGFloat = 66
private let padding: CGFloat = 0

private let itemCount = 10000

private let titleSpace: CGFloat = flat((1 - goldenRatio) * reulerViewHeight)

protocol RulerViewDelegate: class {
    func didSelectItem(with index: Int)
}

class RulerView1: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var rulerViewDelegate: RulerViewDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = RulerLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = padding
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleSpace, width: self.frame.width, height: self.frame.height - titleSpace), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        let margin = (self.frame.width - itemWidth) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: CGRect(x: self.frame.width / 2 - 40, y: 0, width: 80, height: titleSpace))
        textLabel.textAlignment = .center
        textLabel.text = "0.00"
        return textLabel
    }()

    private lazy var verticalLine: CALayer = {
        let verticalLine = CALayer()
        verticalLine.frame = CGRect(x: (self.frame.width - 1) / 2, y: titleSpace, width: 1, height: bottomLineMinY - titleSpace)
        verticalLine.backgroundColor = UIColor.red.cgColor
        return verticalLine
    }()

    private lazy var bottomLine: CALayer = {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: bottomLineMinY, width: self.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        return bottomLine
    }()

    convenience init(origin: CGPoint) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: UIScreen.main.bounds.width, height: reulerViewHeight)))

        backgroundColor = UIColor.white
        addSubview(collectionView)
        collectionView.register(MootsCollectionCell.self, forCellWithReuseIdentifier: "cellID")
        addSubview(textLabel)
        layer.addSublayer(verticalLine)

        layer.addSublayer(bottomLine)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        (cell as? MootsCollectionCell)?.index = indexPath.row
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let index = (scrollView.contentOffset.x + scrollView.contentInset.left) / itemWidth

        textLabel.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.textLabel.alpha = 1
            // 这里有次显示为负数，做一下特殊处理
            self.textLabel.text = String(format: "%.2f", max(Double(index * 100), 0))
        }

        rulerViewDelegate?.didSelectItem(with: Int(index))
    }
}
