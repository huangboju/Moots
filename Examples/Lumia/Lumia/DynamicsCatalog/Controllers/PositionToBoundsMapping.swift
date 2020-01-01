//
//  PositionToBoundsMapping.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/1/1.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

protocol ResizableDynamicItem: UIDynamicItem {
    var bounds: CGRect { set get }
}

class PositionToBoundsMapping: NSObject, UIDynamicItem {
    var center: CGPoint {
        set {
            target.bounds = CGRect(origin: .zero, size: CGSize(width: newValue.x, height: newValue.y))
        }
        get {
            return CGPoint(x: target.bounds.width, y: target.bounds.height)
        }
    }
    
    var bounds: CGRect {
        return target.bounds
    }

    var transform: CGAffineTransform {
        set {
            target.transform = newValue
        }
        get {
            return target.transform
        }
    }
    
    private var target: ResizableDynamicItem
    
    init(target: ResizableDynamicItem) {
        self.target = target
    }
}
