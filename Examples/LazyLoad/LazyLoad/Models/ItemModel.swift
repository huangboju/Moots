//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import SwiftyJSON

typealias DATA = JSON

struct ItemModel {
    /// 类型
    var type = ""
    // data
    var image: String?
    var text: String?
    var id = 0
    /// 标题
    var title = ""
    /// 描述
    var description = ""
    /// 分类
    var category = ""
    /// 时间
    var duration = 0
    /// url
    var playUrl = ""
    /// 背景图
    var feed = ""
    /// 模糊背景
    var blurred = ""
    /// 副标题
    var subTitle: String {
        get {
          return "#\(category))"
        }
    }
    // 喜欢数
    var collectionCount = 0
    // 分享数
    var shareCount = 0
    // 评论数
    var replyCount = 0
    
    init() {}
    
    init(dict: [String : DATA]?) {
        self.type = dict?["type"]?.string ?? ""
        let dataDict = dict?["data"]?.dictionary ?? dict
        image = dataDict?["image"]?.string
        text = dataDict?["text"]?.string
        id = dataDict?["id"]?.int ?? 0
        title = dataDict?["title"]?.string ?? ""
        description = dataDict?["description"]?.string ?? ""
        category = dataDict?["category"]?.string ?? ""
        duration = dataDict?["duration"]?.int ?? 0
        playUrl = dataDict?["playUrl"]?.string ?? ""
        
        // 图片
        feed = dataDict?["cover"]?["feed"].string ?? ""
        blurred = dataDict?["cover"]?["blurred"].string ?? ""
        
        // 评论喜欢分享数量
        let consumptionDict = dataDict?["consumption"]?.dictionary
        if let consumption = consumptionDict {
            collectionCount = consumption["collectionCount"]?.int ?? 0
            shareCount = consumption["shareCount"]?.int ?? 0
            replyCount = consumption["replyCount"]?.int ?? 0
        }
    }
}
