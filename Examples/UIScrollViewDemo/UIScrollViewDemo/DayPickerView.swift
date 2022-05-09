//
//  DayPickerView.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

private let itemSide: CGFloat = 75
private let padding: CGFloat = 40

extension CGSize {
    var rect: CGRect {
        return CGRect(origin: .zero, size: self)
    }
    
    var flatted: CGSize {
        return CGSize(width: flat(width), height: flat(height))
    }
}

class DayPicker: UIView {

    fileprivate var items: [String]!

    private lazy var collectionView: UICollectionView = {
        let layout = RulerLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemSide, height: itemSide)
        layout.minimumLineSpacing = padding
        layout.usingScale = true
        let collectionView = UICollectionView(frame: self.frame.size.rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    convenience init(origin: CGPoint, items: [String]) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: UIScreen.main.bounds.width, height: 100)))
        self.items = items
        backgroundColor = UIColor.white
        addSubview(collectionView)
        collectionView.register(DayPickerCell.self, forCellWithReuseIdentifier: "cellID")
    }
}

extension DayPicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        (cell as? DayPickerCell)?.text = items[indexPath.row]
        return cell
    }
}

extension DayPicker: UICollectionViewDelegate {}

class DayPickerCell: UICollectionViewCell {
    private lazy var textLayer: CXETextLayer = {
        let textLayer = CXETextLayer()
        textLayer.frame = self.bounds
        textLayer.bounds = self.bounds
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.red.cgColor
        textLayer.cornerRadius = self.bounds.width / 2
        return textLayer
    }()

    var text: String? {
        didSet {
            textLayer.string = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.addSublayer(textLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CXETextLayer: CATextLayer {
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }

    override func draw(in ctx: CGContext) {
        let height = bounds.height
        let fontSize = self.fontSize
        let yDiff = (height - fontSize) / 2 - fontSize / 10

        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
