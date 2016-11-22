//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    private struct AssociatedKeys {
        static var badgeKey = "badgeKey"
        static var badgeValueKey = "badgeValueKey"
        static var badgeBGColorKey = "badgeBGColorKey"
        static var badgeTextColorKey = "badgeTextColorKey"
        static var badgeFontKey = "badgeFontKey"
        static var badgePaddingKey = "badgePaddingKey"
        static var badgeMinSizeKey = "badgeMinSizeKey"
        static var badgeOriginXKey = "badgeOriginXKey"
        static var badgeOriginYKey = "badgeOriginYKey"
        static var shouldHideBadgeAtZeroKey = "shouldHideBadgeAtZeroKey"
        static var shouldAnimateBadgeKey = "shouldAnimateBadgeKey"
    }

    func badgeInit() {
        var superview: UIView?
        var defaultOriginX: CGFloat = 0
        if let customView = self.customView {
            superview = customView
            defaultOriginX = superview!.frame.width - badge!.frame.width / 2
        } else if responds(to: #selector(getter: UITouch.view)) {
            if let view = value(forKey: "_view") {
                superview = (view as? UIView)
                defaultOriginX = superview!.frame.width - badge!.frame.width
            }
        }
        
        superview?.addSubview(badge!)
        badgeOriginX = defaultOriginX + 3
    }
    
    func refreshBadge() {
        badge?.textColor = badgeTextColor
        badge?.backgroundColor = badgeBGColor
        badge?.font = badgeFont
        
        if badgeValue == nil || badgeValue == "" || (badgeValue == "0" && shouldHideBadgeAtZero) {
            badge?.isHidden = true
        } else {
            badge?.isHidden = false
            updateBadgeValue(animated: true)
        }
    }
    
    var badgeExpectedSize: CGSize {
        let frameLabel = duplicateLabel(labelToCopy: badge!)
        frameLabel.sizeToFit()
        return frameLabel.frame.size
    }
    
    func updateBadgeFrame() {

        let expectedLabelSize = badgeExpectedSize
        var minHeight = expectedLabelSize.height
        minHeight = max(minHeight, badgeMinSize)
        var minWidth = expectedLabelSize.width
        let padding = badgePadding
        minWidth = max(minWidth, minHeight)

        badge?.layer.masksToBounds = true
        badge?.layer.cornerRadius = (minHeight + padding) / 2
        badge?.frame = CGRect(x: badgeOriginX, y: badgeOriginY, width: minWidth + padding, height: minHeight + padding)
    }

    func updateBadgeValue(animated: Bool) {
        if animated && shouldAnimateBadge && badge?.text != badgeValue {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = NSNumber(value: 1.5)
            animation.toValue = NSNumber(value: 1)
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1, 1)
            badge?.layer.add(animation, forKey: "bounceAnimation")
        }
        
        badge?.text = badgeValue
        if animated && shouldAnimateBadge {
            UIView.animate(withDuration: 0.2, animations: { 
                self.updateBadgeFrame()
            })
        } else {
            updateBadgeFrame()
        }
    }
    
    func removeBadge() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.badge?.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (flag) in
                self.badge?.removeFromSuperview()
                self.badge = nil
        }
    }
    
    func duplicateLabel(labelToCopy: UILabel) -> UILabel {
        let duplicateLabel = UILabel(frame: labelToCopy.frame)
        duplicateLabel.text = labelToCopy.text
        duplicateLabel.font = labelToCopy.font
        return duplicateLabel
    }
    
    var badge: UILabel? {
        get {
            var label = objc_getAssociatedObject(self, &AssociatedKeys.badgeKey) as? UILabel
            if label == nil {
                label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                self.badge = label!
                badgeInit()
                customView?.addSubview(label!)
                label?.textAlignment = .center
            }
            return label!
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var badgeValue: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeValueKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeValueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBadgeValue(animated: true)
            refreshBadge()
        }
    }
    
    var badgeBGColor: UIColor {
        get {
            let color = objc_getAssociatedObject(self, &AssociatedKeys.badgeBGColorKey) as?  UIColor
            return  color ?? UIColor.red
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeBGColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBadgeValue(animated: true)
            refreshBadge()
        }
    }
    
    var badgeTextColor: UIColor {
        get {
            let color = objc_getAssociatedObject(self, &AssociatedKeys.badgeTextColorKey) as?  UIColor
            return color ?? UIColor.white
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeTextColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBadgeValue(animated: true)
            refreshBadge()
            if badge != nil {
                refreshBadge()
            }
        }
    }
    
    /// Defatul UIFont.smallSystemFontSize
    var badgeFont: UIFont {
        get {
            let font = objc_getAssociatedObject(self, &AssociatedKeys.badgeFontKey) as? UIFont
            return font ?? UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                refreshBadge()
            }
        }
    }
    
    /// Defatult 1.5
    var badgePadding: CGFloat {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgePaddingKey) as? CGFloat
            return number ?? 1.5
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgePaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    /// Defatult 8
    var badgeMinSize: CGFloat {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeMinSizeKey) as? CGFloat
            return number ?? 8
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeMinSizeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    /// Defatul 0
    var badgeOriginX: CGFloat {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeOriginXKey) as? CGFloat
            return number ?? 0
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeOriginXKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    /// Defatul -4
    var badgeOriginY: CGFloat {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeOriginYKey) as? CGFloat
            return number ?? -4
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeOriginYKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }

    var shouldHideBadgeAtZero: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.shouldHideBadgeAtZeroKey) as? NSNumber
            return number?.boolValue ?? true
        }
        
        set {
            let number = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.shouldHideBadgeAtZeroKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }

    var shouldAnimateBadge: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.shouldAnimateBadgeKey) as? NSNumber
            return number?.boolValue ?? true
        }
        
        set {
            let number = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.shouldAnimateBadgeKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                refreshBadge()
            }
        }
    }
}
