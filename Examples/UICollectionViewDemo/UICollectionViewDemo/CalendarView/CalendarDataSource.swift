//
//  CalendarDataSource.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit


typealias ConfigureCell = (_ cell: CalendarEventCell, _ indexPath: IndexPath, _ event: CalendarEvent) -> ()

typealias ConfigureHeaderView = (_ headerView: HeaderView, _ kind: String, _ indexPath: IndexPath) -> ()

class CalendarDataSource: NSObject, UICollectionViewDataSource {

    var configureCell: ConfigureCell?
    var configureHeaderView: ConfigureHeaderView?

    private var events: [CalendarEvent] = []
    
    private func generateSampleData() {
        for _ in 0 ..< 20 {
            let event = SampleCalendarEvent.random
            events.append(event)
        }
    }

    func event(at indexPath: IndexPath) -> CalendarEvent {
        return events[indexPath.row]
    }
    
    func indexPathsOfEventsBetweenMinDayIndex(_ minDayIndex: Int, maxDayIndex: Int, minStartHour: Int, maxStartHour: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()

        for (i, event) in events.enumerated() {
            if event.day >= minDayIndex && event.day <= maxDayIndex && event.startHour >= minStartHour && event.startHour <= maxStartHour {
                let indexPath = IndexPath(row: i, section: 0)
                indexPaths.append(indexPath)
            }
        }
        
        return indexPaths
    }
    
    
    override init() {
        super.init()
        generateSampleData()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarEventCell", for: indexPath)

        configureCell?(cell as! CalendarEventCell, indexPath, event)
        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)

        configureHeaderView?(headerView as! HeaderView, kind, indexPath)

        return headerView
    }
}
