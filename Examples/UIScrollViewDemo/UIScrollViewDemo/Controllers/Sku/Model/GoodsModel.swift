//
//  GoodsModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

struct Variant: Codable, Hashable {

    let id: String
    let name: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        value = try values.decodeIfPresent(String.self, forKey: .value) ?? ""
    }

    init(id: String = "", name: String = "", value: String = "") {
        self.id = id
        self.name = name
        self.value = value
    }

    static func == (lhs: Variant, rhs: Variant) -> Bool {
        return lhs.id == rhs.id &&
            rhs.name == lhs.name &&
            rhs.value == lhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(value)
    }
}

struct Variants: Codable {

    let id: String
    let name: String
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case values
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
    }
}


class SpuExtension: Codable {
    let activityFlag: String

    enum CodingKeys: String, CodingKey {
        case activityFlag
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activityFlag = try values.decodeIfPresent(String.self, forKey: .activityFlag) ?? "0"
    }

    init() {
        activityFlag = "0"
    }

    var dict: [String: Any] {
        [CodingKeys.activityFlag.rawValue: activityFlag]
    }

    var isActivity: Bool {
        return activityFlag == "1" ? true : false
    }
}


class SkuGoods: Codable {

    enum Status: Int, Codable {
        case normal = 1
        // 售罄
        case sellOut = 2
        // 下架
        case notSale = 3
    }

    let id: String
    let image: String
    let status: Status
    let mainImage: String
    let name: String
    let price: String
    let variants: [Variant]
    let `extension`: SpuExtension
    let title: String

    public private(set) lazy var variantSet: Set<Variant> = {
       return Set(variants)
    }()

    var isActivity: Bool {
        `extension`.isActivity
    }

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case status = "item_status"
        case mainImage = "main_image"
        case name
        case price
        case variants
        case `extension` = "extension"
        case title
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        status = try values.decodeIfPresent(Status.self, forKey: .status) ?? .normal
        mainImage = try values.decodeIfPresent(String.self, forKey: .mainImage) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? ""
        variants = try values.decodeIfPresent([Variant].self, forKey: .variants) ?? []
        `extension` = try values.decodeIfPresent(SpuExtension.self, forKey: .extension) ?? SpuExtension()
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }

    init() {
        id = ""
        image = ""
        status =  .normal
        mainImage = ""
        name = ""
        price = ""
        variants = []
        `extension` = SpuExtension()
        title = ""
    }
}

class GoodsAllVariant: Codable {

    let goodsList: [SkuGoods]

    let variants: [Variants]

    let spuId: String

    enum CodingKeys: String, CodingKey {
        case goodsList = "content"
        case variants = "sku_list"
        case spuId = "spu_id"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        goodsList = try values.decodeIfPresent([SkuGoods].self, forKey: .goodsList) ?? []
        variants = try values.decodeIfPresent([Variants].self, forKey: .variants) ?? []
        spuId = try values.decodeIfPresent(String.self, forKey: .spuId) ?? ""
    }

    init() {
        goodsList = []
        variants = []
        spuId = ""
    }
}


class GoodsModel: Codable {

    let goodsAllVariant: GoodsAllVariant

    enum CodingKeys: String, CodingKey {
        case goodsAllVariant = "goods_all_variant"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        goodsAllVariant = try values.decodeIfPresent(GoodsAllVariant.self, forKey: .goodsAllVariant) ?? GoodsAllVariant()
    }

    public var goodsList: [SkuGoods] {
        goodsAllVariant.goodsList
    }

    public var variants: [Variants] {
        goodsAllVariant.variants
    }

    public private(set) lazy var goodsMap: [String: SkuGoods] = {
        var result: [String: SkuGoods] = [:]
        goodsList.forEach { result[$0.id] = $0 }
        return result
    }()
}
