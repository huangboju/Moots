//
//  CalendarEvent.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

protocol CalendarEvent {
    var title: String { set get }
    var day: Int { set get }
    var startHour: Int { set get }
    var durationInHours: Int { set get }
}



