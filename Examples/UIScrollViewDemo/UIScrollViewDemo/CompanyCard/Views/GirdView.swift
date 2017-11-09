//
//  GirdView.swift
//  DaDaXTStuMo
//
//  Created by 黄伯驹 on 2017/8/23.
//  Copyright © 2017年 dadaabc. All rights reserved.
//

import UIKit
import Kingfisher

struct GirdItem {
    let imageName: String
    let title: String
}

protocol GirdViewDelegate: class {
    func didSelectItem<T>(at indexPath: IndexPath, item: T)
}


protocol GirdCellType {
    associatedtype ViewData
    func updateCell(with item: ViewData)
}

class GirdView<C>: UIView, UICollectionViewDataSource, UICollectionViewDelegate where C: UICollectionViewCell, C: GirdCellType {

    public weak var girdItemDelegate: GirdViewDelegate?

    /// Default items.count
    public var numberOfCols = 0

    public var items: [C.ViewData] = []

    public var layout = UICollectionViewFlowLayout() {
        didSet {
            if layout == oldValue { return }
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate =  self
        collectionView.dataSource = self
        collectionView.register(C.self, forCellWithReuseIdentifier: "cellID")
        return collectionView
    }()

    convenience init(items: [C.ViewData]) {
        self.init(frame: .zero)

        numberOfCols = items.count

        layout.minimumInteritemSpacing = 0

        collectionView.collectionViewLayout = layout

        addSubview(collectionView)
        collectionView.backgroundColor = .white

        self.items = items
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = CGSize(width: flat(SCREEN_WIDTH / CGFloat(numberOfCols)), height: frame.height)
        collectionView.frame = bounds
    }

    public func refreshUI() {
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        (cell as? C)?.updateCell(with: items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let item = items[indexPath.row]
        girdItemDelegate?.didSelectItem(at: indexPath, item: item)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = .white

        let backgroundView = UIView(frame: cell.bounds)
        backgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cell.selectedBackgroundView = backgroundView
    }
}



class GirdViewCell: UICollectionViewCell, GirdCellType {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0x4A4A4A)
        titleLabel.font = UIFontMake(12)
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        let superView = UIView()
        contentView.addSubview(superView)
        superView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        superView.addSubview(imageView)
        superView.addSubview(titleLabel)

        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.bottom.centerX.equalToSuperview()
        }
    }

    func updateCell(with item: GirdItem) {
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
