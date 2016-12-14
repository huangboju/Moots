//
//  RectModel.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

class RectModel: NSObject {
    /// 转换后的绝对值rect
    var absRect: CGRect
    /// 业务下标
    var lazyID: String
    
    init(absRect: CGRect, lazyID: String) {
        self.absRect = absRect
        self.lazyID = lazyID
        super.init()
    }
}
