//
//  SampleCalendarEvent.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

struct SampleCalendarEvent: CalendarEvent {
    var title: String
    var day: Int
    var startHour: Int
    var durationInHours: Int
    
    static var random: SampleCalendarEvent {
        
        let randomID = arc4random_uniform(10000)
        let title = "Event #\(randomID)"

        let randomDay = Int(arc4random_uniform(7))
        let randomStartHour = Int(arc4random_uniform(20))
        let randomDuration = Int(arc4random_uniform(5) + 1)

        return SampleCalendarEvent(title: title, day: randomDay, startHour: randomStartHour, durationInHours: randomDuration)
    }
}
