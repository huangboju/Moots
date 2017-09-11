//
//  LinerCardView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/9/4.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width

protocol LinerCardViewDelegate: class {
    func didSelectItem(at index: Int, model: String)
}

class LinerCardView: UIView {
    typealias selectedData = (Int) -> Void
    public var handleBack: selectedData? {
        didSet {
            backClosure = handleBack
        }
    }
    public var scrollHandle: selectedData?
    public weak var delgete: LinerCardViewDelegate?

    fileprivate let width = SCREEN_WIDTH / 375 * 327
    fileprivate let height = (SCREEN_WIDTH / 375 * 327) / 327 * 278

    fileprivate let cellIdentifier = "scrollUpCell"

    fileprivate var backClosure: selectedData?

    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: (self.frame.width - 60) / 2, y: self.height + 50, width: 60, height: 20))
        pageControl.currentPageIndicatorTintColor = UIColor(hex: 0x999999)
        pageControl.pageIndicatorTintColor = UIColor(hex: 0x999999, alpha: 0.3)

        return pageControl
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = MootsLayout()
        layout.usingScale = true
        let inset = (SCREEN_WIDTH - self.width) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: self.width, height: self.height)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    fileprivate var isFirst = true
    fileprivate var currentLevel = 0

    fileprivate lazy var models: [String] = [] /// 图片链接

    init(datas: [String], currentLevel: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: height + 80))
        self.models = datas

        backgroundColor = UIColor.white
        
        addSubview(collectionView)
        collectionView.backgroundColor = backgroundColor

        pageControl.numberOfPages = models.count
        self.currentLevel = currentLevel
        pageControl.currentPage = currentLevel
        addSubview(pageControl)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LinerCardView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        (cell as? CardViewCell)?.model = models[indexPath.row]
        if isFirst {
            isFirst = false
            collectionView.scrollToItem(at: IndexPath(item: self.currentLevel, section: 0), at: .centeredHorizontally, animated: false)
        }
        return cell
    }
}

extension LinerCardView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backClosure?(indexPath.row)
        delgete?.didSelectItem(at: indexPath.row, model: models[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / width)
        if pageControl.currentPage != page {
            pageControl.currentPage = page
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / width)
        scrollHandle?(page)
    }
}

class CardViewCell: UICollectionViewCell {

    private lazy var plateLayer: CALayer = {
        let plateLayer = CALayer()
        plateLayer.backgroundColor = UIColor.white.cgColor
        plateLayer.cornerRadius = 6
        plateLayer.frame = self.bounds
        plateLayer.shadowColor = UIColor(hex: 0xBDBDBD).cgColor
        plateLayer.shadowOffset = CGSize(width: 0, height: 2)
        plateLayer.shadowOpacity = 0.9
        plateLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 6).cgPath
        return plateLayer
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 12, y: 12, width: self.bounds.width - 24, height: self.bounds.height / 278 * 190))
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return imageView
    }()
    
    private lazy var badgeTextLabel: UILabel = {
        let badgeTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 22))
        badgeTextLabel.backgroundColor = UIColor(hex: 0xF44E51)
        badgeTextLabel.font = UIFont.systemFont(ofSize: 12)
        badgeTextLabel.textColor = UIColor.white
        return badgeTextLabel
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 0, height: 0))
        textLabel.textColor = UIColor(hex: 0x333333)
        textLabel.font = UIFont.systemFont(ofSize: 14)
        return textLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 0, height: 0))
        dateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return dateLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 100, height: 20))
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = UIColor(hex: 0xFF8800)
        return statusLabel
    }()

    // 这里圆角用代码切，因为在首页需要考虑性能
    private lazy var avatar: UIImageView = {
        // 58 = 38 + 20
        let avatar = UIImageView(frame: CGRect(x: self.bounds.width - 58, y: 0, width: 38, height: 38))
        avatar.layer.cornerRadius = 19
        avatar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return avatar
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor(hex: 0x666666 )
        return nameLabel
    }()
    
    public var model: String? {
        didSet {
            setTextLabel(with: "哒哒童话馆-Old Mother Hubbard")

            setDateLabel(with: "19:04")
            
            statusLabel.text = "直播中"

            setNameLabel(with: "Alexander")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.addSublayer(plateLayer)
        
        badgeTextLabel.frame.origin.x = imageView.frame.width - badgeTextLabel.frame.width
        imageView.addSubview(badgeTextLabel)
        contentView.addSubview(imageView)

        let imageViewBottom = imageView.frame.maxY

        textLabel.frame.origin.y = imageViewBottom + 14
        contentView.addSubview(textLabel)

        contentView.addSubview(dateLabel)

        contentView.addSubview(statusLabel)

        contentView.addSubview(avatar)
        avatar.frame.origin.y = imageViewBottom + 10

        contentView.addSubview(nameLabel)
        nameLabel.frame.origin.y = avatar.frame.maxY + 2
    }

    private func setTextLabel(with text: String?) {
        textLabel.autoSizeTofit(with: text)

        dateLabel.frame.origin.y = textLabel.frame.maxY + 6
    }

    private func setDateLabel(with text: String?) {
        dateLabel.autoSizeTofit(with: text)

        statusLabel.center.y = dateLabel.center.y
        statusLabel.frame.origin.x = dateLabel.frame.maxX + 10
    }

    private func setNameLabel(with text: String?) {
        nameLabel.autoSizeTofit(with: text)

        nameLabel.center.x = avatar.center.x
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UILabel {
    func autoSizeTofit(with text: String?) {
        self.text = text
        sizeToFit()
    }
}

class MootsLayout: UICollectionViewFlowLayout {
    
    var usingScale = false
    private let _scale: CGFloat = 0.9
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let temp = super.layoutAttributesForElements(in: rect)
        if usingScale {
            for attribute in temp! {
                let distance = abs(attribute.center.x - collectionView!.frame.width * 0.5 - collectionView!.contentOffset.x)
                var scale: CGFloat = _scale
                let w = (collectionView!.frame.width + itemSize.width) * _scale
                if distance >= w {
                    scale = _scale
                } else {
                    scale = scale + (1 - distance / w) * (1 - _scale)
                }
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return temp
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(origin: proposedContentOffset, size: collectionView!.frame.size)
        let temp = super.layoutAttributesForElements(in: rect)
        var gap: CGFloat = 1000
        var a: CGFloat = 0
        for attribute in temp! {
            if gap > abs(attribute.center.x - proposedContentOffset.x - collectionView!.frame.width * 0.5) {
                gap = abs(attribute.center.x - proposedContentOffset.x - collectionView!.frame.width * 0.5)
                a = attribute.center.x - proposedContentOffset.x - collectionView!.frame.width * 0.5
            }
        }
        return CGPoint(x: proposedContentOffset.x + a, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
