//
//  WeekCalendarLayout.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

let DaysPerWeek: Int = 7
let HoursPerDay: Int = 24
let HorizontalSpacing: CGFloat = 10
let HeightPerHour: CGFloat = 50
let DayHeaderHeight: CGFloat = 40
let HourHeaderWidth: CGFloat = 100

class WeekCalendarLayout: UICollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        // Don't scroll horizontally
        let contentWidth = collectionView?.bounds.width ?? UIScreen.main.bounds.width

        // Scroll vertically to display a full day
        let contentHeight = DayHeaderHeight + HeightPerHour * CGFloat(HoursPerDay)

        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // Cells
        let visibleIndexPaths = indexPathsOfItems(in: rect)
        for indexPath in visibleIndexPaths {
            guard let attributes = layoutAttributesForItem(at: indexPath) else {
                continue
            }
            layoutAttributes.append(attributes)
        }

        // Supplementary views
        let dayHeaderViewIndexPaths = indexPathsOfDayHeaderViews(in: rect)
        for indexPath in dayHeaderViewIndexPaths {
            guard let attributes = layoutAttributesForSupplementaryView(ofKind: "DayHeaderView", at: indexPath) else {
                continue
            }
            layoutAttributes.append(attributes)
        }

        let hourHeaderViewIndexPaths = indexPathsOfHourHeaderViews(in: rect)
        for indexPath in hourHeaderViewIndexPaths {
            guard let attributes = layoutAttributesForSupplementaryView(ofKind: "HourHeaderView", at: indexPath) else {
                continue
            }
            layoutAttributes.append(attributes)
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let dataSource = collectionView?.dataSource as! CalendarDataSource

        let event = dataSource.event(at: indexPath)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame(for: event)
        return attributes;
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        let totalWidth = collectionViewContentSize.width
        let item = CGFloat(indexPath.item)

        if elementKind == "DayHeaderView" {
            let availableWidth = totalWidth - HourHeaderWidth
            let widthPerDay = availableWidth / CGFloat(DaysPerWeek)
            attributes.frame = CGRect(x: HourHeaderWidth + widthPerDay * item, y: 0, width: widthPerDay, height: DayHeaderHeight)
            attributes.zIndex = -10
        } else if elementKind == "HourHeaderView" {
            attributes.frame = CGRect(x: 0, y: DayHeaderHeight + HeightPerHour * item, width: totalWidth, height: HeightPerHour)
            attributes.zIndex = -10
        }
        return attributes
    }
    

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - Helpers
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        let minVisibleDay = dayIndexFromXCoordinate(rect.minX)
        let maxVisibleDay = dayIndexFromXCoordinate(rect.maxX)
        let minVisibleHour = hourIndexFromYCoordinate(rect.minY)
        let maxVisibleHour = hourIndexFromYCoordinate(rect.maxY)
        
        //    NSLog(@"rect: %@, days: %d-%d, hours: %d-%d", NSStringFromCGRect(rect), minVisibleDay, maxVisibleDay, minVisibleHour, maxVisibleHour);

        let dataSource = collectionView?.dataSource as! CalendarDataSource

        let indexPaths = dataSource.indexPathsOfEventsBetweenMinDayIndex(minVisibleDay, maxDayIndex: maxVisibleDay, minStartHour: minVisibleHour, maxStartHour: maxVisibleHour)
        return indexPaths
    }

    func dayIndexFromXCoordinate(_ xPosition: CGFloat) -> Int {

        let contentWidth = collectionViewContentSize.width - HourHeaderWidth
        let widthPerDay = contentWidth / CGFloat(DaysPerWeek)
        let dayIndex = max(0, ((xPosition - HourHeaderWidth) / widthPerDay))
        return Int(dayIndex)
    }

    func hourIndexFromYCoordinate(_ yPosition: CGFloat) -> Int {
        let hourIndex = max(0, ((yPosition - DayHeaderHeight) / HeightPerHour))
        return Int(hourIndex)
    }
    
    func indexPathsOfDayHeaderViews(in rect: CGRect) -> [IndexPath] {
        if rect.minY > DayHeaderHeight {
            return []
        }

        let minDayIndex = dayIndexFromXCoordinate(rect.minX)
        let maxDayIndex = dayIndexFromXCoordinate(rect.maxX)

        let indexPaths = (minDayIndex ... maxDayIndex).map {
            IndexPath(row: $0, section: 0)
        }

        return indexPaths
    }
    
    func indexPathsOfHourHeaderViews(in rect: CGRect) -> [IndexPath] {
        if rect.minX > HourHeaderWidth {
            return []
        }

        let minHourIndex = hourIndexFromYCoordinate(rect.minY)
        let maxHourIndex = hourIndexFromYCoordinate(rect.maxY)

        let indexPaths = (minHourIndex ... maxHourIndex).map {
            IndexPath(row: $0, section: 0)
        }
        return indexPaths
    }
    
    func frame(for event: CalendarEvent) -> CGRect {
        let totalWidth = collectionViewContentSize.width - HourHeaderWidth
        let widthPerDay = totalWidth / CGFloat(DaysPerWeek)

        var frame = CGRect()
        frame.origin.x = HourHeaderWidth + widthPerDay * CGFloat(event.day)
        frame.origin.y = DayHeaderHeight + HeightPerHour * CGFloat(event.startHour)
        frame.size.width = widthPerDay
        frame.size.height = CGFloat(event.durationInHours) * HeightPerHour

        frame = frame.insetBy(dx: HorizontalSpacing/2.0, dy: 0)
        return frame
    }
}
