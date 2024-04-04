//
//  RecordItem.swift
//  Core Bluetooth HRM
//
//  Created by 黄伯驹 on 2024/3/30.
//  Copyright © 2024 Andrew Jaffee. All rights reserved.
//

import Foundation

public class RecordItem {
    private let recordFileId: String
    private let startTime: Int
    private let size: Int
    var progress = 0
    var status = 0

    
    init(deviceRecordListItem: DeviceRecordListItem) {
        recordFileId = deviceRecordListItem.recordFileId
        startTime = deviceRecordListItem.startTime
        size = deviceRecordListItem.recordSize
    }
}

struct DeviceRecordListItem {
    public let recordFileId: String
    public let recordSize: Int
    public let startTime: Int
}
