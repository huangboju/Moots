//
//  CalendarViewController.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CalendarViewController: UIViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: WeekCalendarLayout())
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    var calendarDataSource: CalendarDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        calendarDataSource = CalendarDataSource()

        collectionView.dataSource = calendarDataSource

        calendarDataSource?.configureCell = { (cell, indexPath, event) in
            cell.titleLabel.text = event.title
        }

        calendarDataSource?.configureHeaderView = { (headerView, kind, indexPath) in
            if kind == "DayHeaderView" {
                headerView.titleLabel.text = "Day \(indexPath.item + 1)"
            } else if kind == "HourHeaderView" {
                headerView.titleLabel.text = "\(indexPath.item + 1):00"
            }
        }

        collectionView.register(CalendarEventCell.self, forCellWithReuseIdentifier: "CalendarEventCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "DayHeaderView", withReuseIdentifier: "HeaderView")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "HourHeaderView", withReuseIdentifier: "HeaderView")

        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
