//
//  InfiniteScrollView.swift
//  MootsLayout_Demo
//
//  Created by 伯驹 黄 on 16/4/5.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView, UIScrollViewDelegate {
    var visibleLabels: [UILabel] = []
    let labelContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        contentSize = CGSize(width: 5000, height: frame.height)
        labelContainerView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height / 2)
        addSubview(labelContainerView)
        labelContainerView.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.width) / 2.0
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        if (distanceFromCenter > (contentWidth / 4.0)) {
            self.contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
            
            // move content by the same amount so it appears to stay still
            for label in visibleLabels {
                var center = labelContainerView.convert(label.center, to: self)
                center.x += (centerOffsetX - currentOffset.x);
                label.center = convert(center, to: labelContainerView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recenterIfNecessary()
        let visibleBounds = convert(bounds, to: labelContainerView)
        let minimumVisibleX = visibleBounds.minX
        let maximumVisibleX = visibleBounds.maxX
        tileLabels(from: minimumVisibleX, toMaxX: maximumVisibleX)
    }

    func insertLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 80))
        label.backgroundColor = UIColor.white
        label.numberOfLines = 3
        label.text = "1024 Block Street\nShaffer, CA\n95014"
        labelContainerView.addSubview(label)
        return label
    }
    
    @discardableResult
    func placeNewLabelOnRight(_ rightEdge: CGFloat) -> CGFloat {
        let label = insertLabel()
        visibleLabels.append(label) // add rightmost label at the end of the array
        var frame = label.frame
        frame.origin.x = rightEdge
        frame.origin.y = labelContainerView.bounds.height - frame.height
        label.frame = frame
        
        return frame.maxX
    }
    
    func placeNewLabel(on leftEdge: CGFloat) -> CGFloat {
        let label = insertLabel()
        visibleLabels.insert(label, at: 0) // add leftmost label at the beginning of the array
        
        var frame = label.frame
        frame.origin.x = leftEdge - frame.width
        frame.origin.y = labelContainerView.bounds.height - frame.height
        label.frame = frame
        
        return frame.minX
    }
    
    func tileLabels(from minimumVisibleX: CGFloat, toMaxX maximumVisibleX: CGFloat) {
        if visibleLabels.count == 0 {
            placeNewLabelOnRight(minimumVisibleX)
        }
        
        var lastLabel = visibleLabels.last
        var rightEdge = lastLabel!.frame.maxX
        
        while rightEdge < maximumVisibleX {
            rightEdge = placeNewLabelOnRight(rightEdge)
        }
        
        var firstLabel = visibleLabels[0]
        var leftEdge = firstLabel.frame.minX
        
        while leftEdge > minimumVisibleX {
            leftEdge = placeNewLabel(on: leftEdge)
        }
        
        // remove labels that have fallen off right edge
        lastLabel = visibleLabels.last
        while lastLabel!.frame.minX > maximumVisibleX {
            lastLabel!.removeFromSuperview()
            visibleLabels.removeLast()
            lastLabel = visibleLabels.last
        }
        
        // remove labels that have fallen off left edge
        firstLabel = visibleLabels[0]
        while firstLabel.frame.maxX < minimumVisibleX {
            firstLabel.removeFromSuperview()
            visibleLabels.removeFirst()
            firstLabel = visibleLabels[0]
        }
    }
    
    func nearestTargetOffset(for offset: CGPoint) -> CGPoint {
        let pageSize = bounds.width
        let page = roundf(Float(offset.x / pageSize))
        let targetX = pageSize * CGFloat(page)
        print(offset, targetX)
        return CGPoint(x: targetX, y: offset.y)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        
        
        let targetOffset = nearestTargetOffset(for: targetContentOffset.pointee)
        targetContentOffset.pointee.x = targetOffset.x
        targetContentOffset.pointee.y = targetOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView)
    }
}
