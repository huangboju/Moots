//
//  GoodsInfoCellModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class GoodsInfoCellModel: NSObject {
    var name: String {
        sku.name
    }

    var mainImage: String {
        sku.mainImage
    }

    var image: String {
        if shouldShowMainImage {
            return sku.mainImage
        }
        return sku.image.isEmpty ? sku.mainImage : sku.image
    }

    var sku: SkuGoods

    init(sku: SkuGoods = SkuGoods()) {
        self.sku = sku
        super.init()
    }

    var shouldShowMainImage = false

    var isHiddenChangeButton: Bool {
        sku.mainImage == sku.image || sku.mainImage.isEmpty || sku.image.isEmpty
    }

    var priceAttributedText: NSAttributedString {
        let color = UIColor(hex: 0xD5D7DD)
        let price = sku.price
        let attr = NSMutableAttributedString(string: "¥", attributes: [
            .foregroundColor: color,
            .font: font(with: 12),
            .kern: 1
        ])
        attr.append(NSAttributedString(string: price, attributes: [
            .foregroundColor: color,
            .font: font(with: 20)
        ]))
        return attr
    }

    func font(with size: CGFloat) -> UIFont {
        UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
