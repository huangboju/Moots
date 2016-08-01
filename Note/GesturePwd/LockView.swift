//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockView: UIView {
    var type: CoreLockType?
    var setPasswordHandle: handle?
    var confirmPasswordHandle: handle?
    var passwordTooShortHandle: ((Int) -> Void)?
    var passwordTwiceDifferentHandle: ((password1: String, passwordNow: String) -> Void)?
    var passwordFirstRightHandle: handle?
    var setSuccessHandle: strHandle?
    
    var verifyPasswordHandle: handle?
    var verifySuccessHandle: ((password: String) -> Bool)?
    
    var modifyPasswordHandle: handle?
    var modifySuccessHandle: handle?
    
    private var itemViews = [LockItemView]()
    private var passwordContainer = ""
    private var firstPassword = ""
    private var modify_VeriryOldRight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BACKGROUND_COLOR
        for _ in 0..<9 {
            let itemView = LockItemView()
            addSubview(itemView)
        }
    }
    
    override func drawRect(rect: CGRect) {
        if itemViews.isEmpty { return }
        let context = UIGraphicsGetCurrentContext()
        CGContextAddRect(context, rect)
        itemViews.forEach { (itemView) in
            
            CGContextAddEllipseInRect(context, itemView.frame)
        }
        
        //剪裁
        CGContextEOClip(context)
        
        //新建路径：管理线条
        let path = CGPathCreateMutable()
        
        CoreLockLockLineColor.set()
        CGContextSetLineCap(context, .Round)
        CGContextSetLineJoin(context, .Round)
        CGContextSetLineWidth(context, 1)
        
        for (idx, itemView) in itemViews.enumerate() {
            let directPoint = itemView.center
            if idx == 0 {
                CGPathMoveToPoint(path, nil, directPoint.x, directPoint.y)
            } else {
                CGPathAddLineToPoint(path, nil, directPoint.x, directPoint.y)
            }
        }
        CGContextAddPath(context, path)
        CGContextStrokePath(context)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemViewWH = (frame.width - 4 * ITEM_MARGIN) / 3
        for (idx, subview) in subviews.enumerate() {
            let row = CGFloat(idx % 3)
            let col = CGFloat(idx / 3)
            let x = ITEM_MARGIN * (row + 1) + row * itemViewWH
            let y = ITEM_MARGIN * (col + 1) + col * itemViewWH
            let rect = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            subview.tag = idx
            subview.frame = rect
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lockHandle(touches)
        
        if type == .Set {
            if firstPassword.isEmpty {
                if let setPasswordHandle = setPasswordHandle {
                    setPasswordHandle()
                }
            } else {
                if let confirmPasswordHandle = confirmPasswordHandle {
                    confirmPasswordHandle()
                }
            }
        } else if type == .Veryfy {
            if let verifyPasswordHandle = verifyPasswordHandle {
                verifyPasswordHandle()
            }
        } else if type == .Modify {
            if let modifyPasswordHandle = modifyPasswordHandle {
                modifyPasswordHandle()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lockHandle(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gestureEnd()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        gestureEnd()
    }
    
    func gestureEnd() {
        if !passwordContainer.isEmpty {
            let count = itemViews.count
            if count < MIN_ITEM_COUNT {
                if let passwordTooShortHandle = passwordTooShortHandle {
                    passwordTooShortHandle(count)
                }
                return
            }
            
            if type == .Set {
                setPassword()
            } else if type == .Veryfy {
                if let verifySuccessHandle = verifySuccessHandle {
                    verifySuccessHandle(password: passwordContainer)
                }
            } else if type == .Modify {
                if !modify_VeriryOldRight {
                    if let verifySuccessHandle = verifySuccessHandle {
                        modify_VeriryOldRight = verifySuccessHandle(password: passwordContainer)
                    }
                } else {
                    setPassword()
                }
            }
        }
        
        for item in itemViews {
            item.selected = false
            item.direct = nil
        }
        itemViews.removeAll()
        setNeedsDisplay()
        passwordContainer = ""
    }
    
    private func setPassword() {
        if firstPassword.isEmpty {
            firstPassword = passwordContainer
            if let passwordFirstRightHandle = passwordFirstRightHandle {
                passwordFirstRightHandle()
            }
        } else {
            if firstPassword != passwordContainer {
                if let passwordTwiceDifferentHandle = passwordTwiceDifferentHandle {
                    passwordTwiceDifferentHandle(password1: firstPassword, passwordNow: passwordContainer)
                }
                return
            } else {
                if let setSuccessHandle = setSuccessHandle {
                    setSuccessHandle(firstPassword)
                }
            }
        }
    }
    
    func lockHandle(touches: Set<UITouch>) {
        let touch = touches.first
        let location = touch?.locationInView(self)
        if let itemView = itemViewWithTouchLocation(location) {
            if itemViews.contains(itemView) {
                return
            }
            itemViews.append(itemView)
            passwordContainer += itemView.tag.description
            calDirect()
            itemView.selected = true
            setNeedsDisplay()
        }
    }
    
    func calDirect() {
        let count = itemViews.count
        if itemViews.count > 1 {
            let last_1_ItemView = itemViews.last
            let last_2_ItemView = itemViews[count - 2]
            
            let last_1_x = last_1_ItemView?.frame.minX
            let last_1_y = last_1_ItemView?.frame.minY
            let last_2_x = last_2_ItemView.frame.minX
            let last_2_y = last_2_ItemView.frame.minY
            
            if last_2_x == last_1_x && last_2_y > last_1_y {
                last_2_ItemView.direct = .Top
            }
            if last_2_y == last_1_y && last_2_x > last_1_x {
                last_2_ItemView.direct = .Left
            }
            if last_2_x == last_1_x && last_2_y < last_1_y {
                last_2_ItemView.direct = .Bottom
            }
            if last_2_y == last_1_y && last_2_x < last_1_x {
                last_2_ItemView.direct = .Right
            }
            if last_2_x > last_1_x && last_2_y > last_1_y {
                last_2_ItemView.direct = .LeftTop
            }
            if last_2_x < last_1_x && last_2_y > last_1_y {
                last_2_ItemView.direct = .RightTop
            }
            if last_2_x > last_1_x && last_2_y < last_1_y {
                last_2_ItemView.direct = .LeftBottom
            }
            if last_2_x < last_1_x && last_2_y < last_1_y {
                last_2_ItemView.direct = .RightBottom
            }
        }
    }
    
    func itemViewWithTouchLocation(location: CGPoint?) -> LockItemView? {
        var item: LockItemView?
        for subView in subviews {
            if let itemView = (subView as? LockItemView) {
                if !CGRectContainsPoint(itemView.frame, location!) {
                    continue
                }
                item = itemView
                break
            }
        }
        return item
    }
    
    func resetPassword() {
        firstPassword = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
