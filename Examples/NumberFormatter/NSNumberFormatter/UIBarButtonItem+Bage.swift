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
        badgeBGColor = .red
        badgeTextColor = .white
        badgeFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        badgePadding = 6
        badgeMinSize = 8
        badgeOriginX = defaultOriginX
        badgeOriginY = -4
        shouldHideBadgeAtZero = true
        shouldAnimateBadge = true
    }
    
    func refreshBadge() {
        badge?.textColor = badgeTextColor
        badge?.backgroundColor = badgeBGColor
        badge?.font = badgeFont
        
        if badgeValue != nil || badgeValue == "" || badgeValue == "0" && shouldHideBadgeAtZero {
            badge?.isHidden = true
        } else {
            badge?.isHidden = false
            updateBadgeValue(animated: true)
        }
    }
    
    func badgeExpectedSize() -> CGSize {
        let frameLabel = duplicateLabel(labelToCopy: badge!)
        frameLabel.sizeToFit()
        return frameLabel.frame.size
    }
    
    func updateBadgeFrame() {
        let expectedLabelSize = badgeExpectedSize()
        var minHeight = expectedLabelSize.height
        minHeight = (minHeight < badgeMinSize!) ? badgeMinSize! : expectedLabelSize.height
        var minWidth = expectedLabelSize.width
        let padding = badgePadding
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        badge?.layer.masksToBounds = true
        badge?.frame = CGRect(x: badgeOriginX!, y: badgeOriginY!, width: minWidth + padding!, height: minHeight + padding!)
        badge?.layer.cornerRadius = (minHeight + padding!) / 2
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
                label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
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
    
    var badgeBGColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeBGColorKey) as?  UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeBGColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBadgeValue(animated: true)
            refreshBadge()
        }
    }
    
    var badgeTextColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeTextColorKey) as?  UIColor
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
    
    var badgeFont: UIFont? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeFontKey) as? UIFont
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                refreshBadge()
            }
        }
    }
    
    var badgePadding: CGFloat? {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgePaddingKey) as? NSNumber
            return CGFloat(number?.floatValue ?? 0)
        }
        
        set {
            let number = NSNumber(value: Float(newValue ?? 0))
            objc_setAssociatedObject(self, &AssociatedKeys.badgePaddingKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    var badgeMinSize: CGFloat? {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeMinSizeKey) as? NSNumber
            return CGFloat(number?.floatValue ?? 0)
        }
        
        set {
            let number = NSNumber(value: Double(newValue ?? 0))
            objc_setAssociatedObject(self, &AssociatedKeys.badgeMinSizeKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    var badgeOriginX: CGFloat? {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeOriginXKey) as? NSNumber
            return CGFloat(number?.floatValue ?? 0)
        }
        
        set {
            let number = NSNumber(value: Double(newValue ?? 0))
            objc_setAssociatedObject(self, &AssociatedKeys.badgeOriginXKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    var badgeOriginY: CGFloat? {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.badgeOriginYKey) as? NSNumber
            return CGFloat(number?.floatValue ?? 0)
        }
        
        set {
            let number = NSNumber(value: Double(newValue ?? 0))
            objc_setAssociatedObject(self, &AssociatedKeys.badgeOriginYKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if badge != nil {
                updateBadgeFrame()
            }
        }
    }
    
    var shouldHideBadgeAtZero: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.shouldHideBadgeAtZeroKey) as? NSNumber
            return number?.boolValue ?? false
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
            return number?.boolValue ?? false
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
