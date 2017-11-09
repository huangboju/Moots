//
//  File.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsRecommendViewCell: UICollectionViewCell, Reusable {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = generatLabel(with: UIFontMake(14))
        titleLabel.backgroundColor = UIColor.blue
        return titleLabel
    }()

    private lazy var pormtLabel: UILabel = {
        let pormtLabel = generatLabel(with: UIFontMake(12))
        pormtLabel.textColor = UIColor(hex: 0x4A4A4A)
        pormtLabel.backgroundColor = UIColor.red
        return pormtLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(white: 0.9, alpha: 1)

        contentView.addSubview(imageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(pormtLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        
        imageView.frame = CGSize(width: width, height: 125).rect

        titleLabel.frame = CGRect(x: 11, y: imageView.frame.maxY + 6, width: width - 22, height: 20)

        pormtLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 2, width: width - 22, height: 17)
    }
    
    private func generatLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        return label
    }
    
    public func updateCell() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyCoRightsRecommendView: UIView {
    
    public var data: [String] = []
    
    private let layout = UICollectionViewFlowLayout()
    
    private(set) var collectionView: UICollectionView!

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds

        layout.itemSize = CGSize(width: (bounds.width - 3) / 2, height: 181)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView = {
            self.layout.minimumLineSpacing = 11
            self.layout.minimumInteritemSpacing = 3

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .white
            collectionView.register(cellType: MyCoRightsRecommendViewCell.self)

            return collectionView
        }()

        addSubview(collectionView)
    }

    private weak var headerView: FormView?

    public func addHeaderView(_ headerView: FormView) {
        self.headerView = headerView
        collectionView.addSubview(headerView)
    }
    
    public func freshView() {
        collectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyCoRightsRecommendView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCoRightsRecommendViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.updateCell()
        return cell
    }
}

extension MyCoRightsRecommendView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        headerView?.layoutIfNeeded()
        // 导航栏似乎有影响
        guard var size = headerView?.contentSize else {
            return .zero
        }
        print(size)
        size.height -= 64
        return size
    }
}

