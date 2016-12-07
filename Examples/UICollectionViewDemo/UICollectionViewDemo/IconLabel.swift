//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

enum IconDirection {
    case Left, Right, Top, Bottom
}

class IconLabel: UILabel {
    var edgeInsets = UIEdgeInsets()
    var direction = IconDirection.Left
    var gap: CGFloat = 5
    var icon: UIImage? {
        didSet {
            if let iconView = iconView {
                iconView.image = icon
            } else {
                iconView = UIImageView(image: icon)
            }
            iconView?.frame.origin = CGPoint.zero
            addSubview(iconView ?? UIImageView())
        }
    }

    private var iconView: UIImageView?

    override var text: String? {
        didSet {
            sizeToFit()
        }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.height += (edgeInsets.top + edgeInsets.bottom)
        switchFunc({
            if let iconView = iconView {
                if iconView.isMember(of: UIImageView.self) {
                    rect.size.width += (edgeInsets.left + edgeInsets.right + gap + iconView.frame.width)
                }
            } else {
                rect.size.width += (edgeInsets.left + edgeInsets.right)
            }
        }) {
            if let iconView = iconView {
                if iconView.isMember(of: UIImageView.self) {
                    rect.size.height += (edgeInsets.top + edgeInsets.bottom + gap + iconView.frame.height)
                }
            } else {
                rect.size.height += (edgeInsets.bottom + edgeInsets.top)
            }
        }
        return rect
    }

    override func drawText(in rect: CGRect) {
        var temp = edgeInsets
        if let iconView = iconView {
            switchFunc({
                iconView.center.y = bounds.height / 2
                if direction == .Left {
                    iconView.frame.origin.x = edgeInsets.left
                    temp = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left + gap + iconView.frame.width, bottom: edgeInsets.bottom, right: edgeInsets.right)
                } else {
                    iconView.frame.origin.x = frame.width - edgeInsets.right - iconView.frame.width
                    temp = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right + gap + iconView.frame.width)
                }
            }, vertical: {
                iconView.center.x = bounds.width / 2
                if direction == .Top {
                    iconView.frame.origin.y = 0
                    temp = UIEdgeInsets(top: edgeInsets.top + gap + iconView.frame.height, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
                } else {
                    iconView.frame.origin.y = edgeInsets.bottom + iconView.frame.height
                    temp = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom + gap + iconView.frame.height, right: edgeInsets.right)
                }
            })
        }
        super.drawText(in: UIEdgeInsetsInsetRect(rect, temp))
    }

    private func switchFunc(_ horizontal: () -> Void, vertical: () -> Void) {
        switch direction {
        case .Left, .Right:
            horizontal()
        default:
            vertical()
        }
    }
}
