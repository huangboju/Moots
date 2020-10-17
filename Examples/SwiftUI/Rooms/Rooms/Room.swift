//
//  Room.swift
//  Rooms
//
//  Created by jourhuang on 2020/10/17.
//

import SwiftUI

struct Room: Identifiable {
    var id = UUID()
    var name: String
    var capacity: Int
    var hasVideo = false
}

let testData = [
    Room(name: "房间1", capacity: 6, hasVideo: true),
    Room(name: "卧室", capacity: 8, hasVideo: true),
    Room(name: "卫生间", capacity: 16, hasVideo: true),
    Room(name: "书房", capacity: 26, hasVideo: false),
    Room(name: "厨房", capacity: 17, hasVideo: false)
]
