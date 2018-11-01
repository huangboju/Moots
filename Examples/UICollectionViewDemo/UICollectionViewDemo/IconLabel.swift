//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

enum IconDirection: Int {
    case left, right, top, bottom
}

class IconLabel: UILabel {
    var edgeInsets = UIEdgeInsets() // 文字偏移量
    var direction = IconDirection.top
    var gap: CGFloat = 5

    private var iconView: UIImageView?
    
    func set(_ text: String?, with image: UIImage?) {
        self.text = text
        if let iconView = iconView {
            iconView.image = image
        } else {
            iconView = UIImageView(image: image)
        }
        iconView?.frame.origin = CGPoint.zero
        addSubview(iconView ?? UIImageView())
        // 1
        sizeToFit()
        // 3
    }
    
    private var offsetX: CGFloat = 0

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // 2
        var rect = super.textRect(forBounds: bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines)
        let h = edgeInsets.left + edgeInsets.right
        let v = edgeInsets.bottom + edgeInsets.top
        let w = max(rect.width, iconView?.frame.width ?? 0)
        offsetX = (w - rect.width) / 2
        rect.size.height = (max(rect.height, iconView?.frame.height ?? 0)) + v
        rect.size.width = w + h
        switch direction {
        case .left, .right:
            rect.origin.x -= edgeInsets.left
            if let iconView = iconView {
               rect.size.width += (gap + iconView.frame.width)
            }
        default:
            rect.origin.y -= edgeInsets.top
            if let iconView = iconView {
                rect.size.height += (gap + iconView.frame.height)
            }
        }
        return rect
    }

    override func drawText(in rect: CGRect) {
        // 4(这里应该是异步的，如果循环创建多个IconDirection，最后同时执行这个方法)
        var temp = edgeInsets
        if let iconView = iconView {
            switch direction {
            case .left, .right:
                iconView.center.y = bounds.height / 2
                if direction == .left {
                    iconView.frame.origin.x = edgeInsets.left
                    temp = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left + gap + iconView.frame.width, bottom: edgeInsets.bottom, right: edgeInsets.right)
                } else {
                    iconView.frame.origin.x = frame.width - edgeInsets.right - iconView.frame.width
                    temp = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right + gap + iconView.frame.width)
                }
            default:
                iconView.center.x = bounds.width / 2
                if direction == .top {
                    iconView.frame.origin.y = 0
                    temp = UIEdgeInsets(top: edgeInsets.top + gap + iconView.frame.height, left: offsetX + edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
                } else {
                    iconView.frame.origin.y = edgeInsets.bottom + iconView.frame.height
                    temp = UIEdgeInsets(top: edgeInsets.top, left: offsetX + edgeInsets.left, bottom: edgeInsets.bottom + gap + iconView.frame.height, right: edgeInsets.right)
                }
            }
        }
        super.drawText(in: rect.inset(by: temp))
    }
}
