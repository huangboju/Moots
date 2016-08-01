//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockView: UIView {
    var type: CoreLockType?
    var setPasswordHandle: (() -> Void)?
    var setPWConfirmlock: (() -> Void)?
    var setPWSErrorLengthTooShortBlock: ((Int) -> Void)?
    var setPWSErrorTwiceDiffBlock: ((password1: String, passwordNow: String) -> Void)?
    var setPWFirstRightBlock: (() -> Void)?
    var setPWTwiceSameBlock: ((password: String) -> Void)?
    
    var verifyPWBeginBlock: (() -> Void)?
    
    var verifyPwdBlock: ((password: String) -> Bool)?
    
    var modifyPwdBlock: (() -> Void)?
    
    var modifyPwdSuccessBlock: (() -> Void)?
    
    private let marginValue: CGFloat = 36
    
    private var itemViewsM = [LockItemView]()
    private var pwdM = ""
    private var firstRightPWD = ""
    private var modify_VeriryOldRight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CoreLockViewBgColor
        for _ in 0..<9 {
            let itemView = LockItemView()
            addSubview(itemView)
        }
    }
    
    override func drawRect(rect: CGRect) {
        if itemViewsM.isEmpty { return }
        let context = UIGraphicsGetCurrentContext()
        CGContextAddRect(context, rect)
        itemViewsM.forEach { (itemView) in
            
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
        
        for (idx, itemView) in itemViewsM.enumerate() {
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
        let itemViewWH = (frame.width - 4 * marginValue) / 3
        for (idx, subview) in subviews.enumerate() {
            let row = CGFloat(idx % 3)
            let col = CGFloat(idx / 3)
            let x = marginValue * (row + 1) + row * itemViewWH
            let y = marginValue * (col + 1) + col * itemViewWH
            let rect = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            subview.tag = idx
            subview.frame = rect
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lockHandle(touches)
        
        if type == .Set {
            if firstRightPWD.isEmpty {
                if let setPasswordHandle = setPasswordHandle {
                    setPasswordHandle()
                }
            } else {
                if let setPWConfirmlock = setPWConfirmlock {
                    setPWConfirmlock()
                }
            }
        } else if type == .Veryfi {
            if let verifyPWBeginBlock = verifyPWBeginBlock {
                verifyPWBeginBlock()
            }
        } else if type == .Modify {
            if let modifyPwdBlock = modifyPwdBlock {
                modifyPwdBlock()
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
        if !pwdM.isEmpty {
            setpwdCheck()
        }
        
        for item in itemViewsM {
            item.selected = false
            item.direct = nil
        }
        itemViewsM.removeAll()
        setNeedsDisplay()
        pwdM = ""
    }
    
    func setpwdCheck() {
        let count = itemViewsM.count
        if count < MIN_ITEM_COUNT {
            if let setPWSErrorLengthTooShortBlock = setPWSErrorLengthTooShortBlock {
                setPWSErrorLengthTooShortBlock(count)
            }
            return
        }
        
        if type == .Set {
            setPassword()
        } else if type == .Veryfi {
            if let verifyPwdBlock = verifyPwdBlock {
                verifyPwdBlock(password: pwdM)
            }
        } else if type == .Modify {
            if !modify_VeriryOldRight {
                if let verifyPwdBlock = verifyPwdBlock {
                    modify_VeriryOldRight = verifyPwdBlock(password: pwdM)
                }
            } else {
                setPassword()
            }
        }
    }
    
    private func setPassword() {
        if firstRightPWD.isEmpty {
            firstRightPWD = pwdM
            if let setPWFirstRightBlock = setPWFirstRightBlock {
                setPWFirstRightBlock()
            }
        } else {
            if firstRightPWD != pwdM {
                if let setPWSErrorTwiceDiffBlock = setPWSErrorTwiceDiffBlock {
                    setPWSErrorTwiceDiffBlock(password1: firstRightPWD, passwordNow: pwdM)
                }
                return
            } else {
                if let setPWTwiceSameBlock = setPWTwiceSameBlock {
                    setPWTwiceSameBlock(password: firstRightPWD)
                }
            }
        }
    }
    
    func lockHandle(touches: Set<UITouch>) {
        let touch = touches.first
        let location = touch?.locationInView(self)
        if let itemView = itemViewWithTouchLocation(location) {
            if itemViewsM.contains(itemView) {
                return
            }
            itemViewsM.append(itemView)
            pwdM += itemView.tag.description
            calDirect()
            itemView.selected = true
            setNeedsDisplay()
        }
    }
    
    func calDirect() {
        let count = itemViewsM.count
        if itemViewsM.count > 1 {
            let last_1_ItemView = itemViewsM.last
            let last_2_ItemView = itemViewsM[count - 2]
            
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
        firstRightPWD = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
