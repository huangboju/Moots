//
//  UIColor+Hex.swift
//  Xcode Flight
//
//  Copyright © 2017 Anton Doudarev. All rights reserved.

import Foundation
import UIKit

var colorCache = [Int : UIColor]()

extension UIColor {
    
    static public func color(forHex hex: Int, withAlpha alpha : CGFloat = 1.0) -> UIColor {
        if let color = colorCache[hex] {
            return color
        }
        
        colorCache[hex] = UIColor(hex : hex, alpha : alpha)
        
        return colorCache[hex]!
    }
}
