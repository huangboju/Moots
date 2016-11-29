//
//  NextPageState.swift
//  Pagination
//
//  Created by 伯驹 黄 on 2016/10/18.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import Foundation

struct NextPageState<T> {
    private(set) var hasNext: Bool
     var isLoading: Bool
    private(set) var lastId: T?
    
    init() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func reset() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func update(hasNext: Bool, isLoading: Bool, lastId: T?) {
        self.hasNext = hasNext
        self.isLoading = isLoading
        self.lastId = lastId
    }
}
