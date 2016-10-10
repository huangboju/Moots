//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct IssueModel {
    /// 时间
    var date: Int16!
    /// 发布时间
    var publishTime: Int16!
    /// 类型
    var type = ""
    /// 数量
    var cound = 0
    /// 是否有headerview
    var isHaveSectionView = false
    var headerTitle: String?
    var headerImage: String?
    
    var itemList = [ItemModel]()
    
    init(dict: [String : DATA]?) {
        date = dict?["date"]?.int16 ?? 0
        publishTime = dict?["publishTime"]?.int16 ?? 0
        type = dict?["type"]?.string ?? ""
        cound = dict?["cound"]?.int ?? 0
        if let itemArray = dict?["itemList"]?.array {
            itemList = itemArray.map { ItemModel(dict: $0.dictionary) }
        }
        
        // 判断是否有headerview
        let firstItemModel = itemList.first
        if firstItemModel?.type == "video" {
            isHaveSectionView = false
        } else if firstItemModel?.type == "textHeader" {
            isHaveSectionView = true
            itemList.removeFirst()
            headerTitle = firstItemModel?.text
        } else if firstItemModel?.type == "imageHeader" {
            isHaveSectionView = true
            itemList.removeFirst()
            headerImage = firstItemModel?.image
        } else {
            isHaveSectionView = false
        }
    }
}
