//
//  HomepageModel.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class HomepageData: Mappable {
    
    var code: Int?
    var msg: String?
    // 其他参数就不写了,这仅仅是个简单的例子
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
    }
}

class Art: Mappable {
    
    var name: String?
    var id: Int?
    var introduction: String?
    var price: CGFloat?
        
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        introduction <- map["introduction"]
        price <- map["price"]
    }
}


