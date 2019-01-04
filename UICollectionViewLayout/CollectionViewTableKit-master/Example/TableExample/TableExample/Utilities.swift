//
//  Utilities.swift
//  TableExample
//
//  Created by Malte Schonvogel on 30.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

let isIphone = UIDevice.current.userInterfaceIdiom == .phone
let isIpad = UIDevice.current.userInterfaceIdiom == .pad

let spacing: CGFloat = isIpad ? 20 : 15

extension UIEdgeInsets {

    init(allSides: CGFloat) {

        self.init(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}


extension NSMutableAttributedString {
    
    func setTextColor(color: UIColor) {

        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: length))
    }

    func setTextAlignment(alignment: NSTextAlignment) {

        let range = NSRange(location: 0, length: length)
        let style = NSMutableParagraphStyle()
        style.alignment = alignment

        addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
    }
}
