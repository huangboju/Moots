//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

enum LockItemViewDirect: Int {
    case Top = 1
    case RightTop
    case Right
    case RightBottom
    case Bottom
    case LeftBottom
    case Left
    case LeftTop
}

class LockItemView: UIView {
    var direct: LockItemViewDirect? {
        willSet {
            if let newValue = newValue {
                angle = CGFloat(M_PI_4) * CGFloat(newValue.rawValue - 1)
                setNeedsDisplay()
            }
        }
    }
    var selected: Bool = false {
        willSet {
            setNeedsDisplay()
        }
    }
    
    private var calRect: CGRect {
        set {
            storeCalRect = newValue
        }
        get {
            if CGRectEqualToRect(storeCalRect, CGRect.zero) {
                let sizeWH = bounds.width - ARC_LINE_WIDTH
                let originXY = ARC_LINE_WIDTH * 0.5
                self.storeCalRect = CGRect(x: originXY, y: originXY, width: sizeWH, height: sizeWH)
            }
            return storeCalRect
        }
    }
    private var storeCalRect = CGRect()
    private var selectedRect: CGRect {
        set {
            storeSelectedRect = newValue
        }
        get {
            if CGRectEqualToRect(self.storeSelectedRect, CGRect.zero) {
                let selectRectWH = bounds.width * ARC_WHR
                let selectRectXY = bounds.width * (1 - ARC_WHR) * 0.5
                storeSelectedRect = CGRect(x: selectRectXY, y: selectRectXY, width: selectRectWH, height: selectRectWH)
            }
            return storeSelectedRect
        }
    }
    private var storeSelectedRect = CGRect()
    private var angle: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //上下文旋转
        transForm(context, rect: rect)
        //上下文属性设置
        propertySetting(context)
        //外环：普通
        circleNormal(context, rect: rect)
        //选中情况下，绘制背景色
        if selected {
            //外环：选中
            circleSelected(context, rect: rect)
            //三角形：方向标识
            direct(context, rect: rect)
        }
    }
    
    func transForm(context: CGContextRef?, rect: CGRect) {
        let translateXY = rect.width * 0.5
        
        //平移
        CGContextTranslateCTM(context, translateXY, translateXY)
        
        CGContextRotateCTM(context, angle ?? 0)
        
        //再平移回来
        CGContextTranslateCTM(context, -translateXY, -translateXY)
    }
    
    /*
     *  三角形：方向标识
     */
    func directFlag(context: CGContextRef, rect: CGRect) {
        //新建路径：三角形
        let trianglePathM = CGPathCreateMutable()
        let marginSelectedCirclev: CGFloat = 4
        let w: CGFloat = 8
        let h: CGFloat = 5
        let topX = rect.minX + rect.width * 0.5
        let topY = rect.minY + (rect.width * 0.5 - h - marginSelectedCirclev - selectedRect.height * 0.5)
        
        CGPathMoveToPoint(trianglePathM, nil, topX, topY)
        
        //添加左边点
        let leftPointX = topX - w * 0.5
        let leftPointY = topY + h
        CGPathAddLineToPoint(trianglePathM, nil, leftPointX, leftPointY)
        
        //右边的点
        let rightPointX = topX + w * 0.5
        CGPathAddLineToPoint(trianglePathM, nil, rightPointX, leftPointY)
        
        //将路径添加到上下文中
        CGContextAddPath(context, trianglePathM)
        
        //绘制圆环
        CGContextFillPath(context)
    }
    
    func propertySetting(context: CGContextRef?) {
        //设置线宽
        CGContextSetLineWidth(context, ARC_LINE_WIDTH)
        if selected {
            CoreLockCircleLineSelectedColor.set()
        } else {
            CoreLockCircleLineNormalColor.set()
        }
    }
    
    func circleNormal(context: CGContextRef?, rect: CGRect) {
        //新建路径：外环
        let loopPath = CGPathCreateMutable()
        
        //添加一个圆环路径
        CGPathAddEllipseInRect(loopPath, nil, calRect)
        
        //将路径添加到上下文中
        CGContextAddPath(context, loopPath)
        
        //绘制圆环
        CGContextStrokePath(context)
    }
    
    func circleSelected(contenxt: CGContextRef?, rect: CGRect) {
        //新建路径：外环
        let circlePath = CGPathCreateMutable()
        
        //绘制一个圆形
        CGPathAddEllipseInRect(circlePath, nil, selectedRect)
        
        CoreLockCircleLineSelectedCircleColor.set()
        
        //将路径添加到上下文中
        CGContextAddPath(contenxt, circlePath);
        
        //绘制圆环
        CGContextFillPath(contenxt)
    }
    
    func direct(ctx: CGContextRef?, rect: CGRect) {
        //新建路径：三角形
        if direct == nil {
            return
        }
        let trianglePathM = CGPathCreateMutable()
        
        let marginSelectedCirclev: CGFloat = 4
        let w: CGFloat = 8
        let h: CGFloat = 5
        let topX = rect.minX + rect.size.width * 0.5
        let topY = rect.minY + (rect.size.width * 0.5 - h - marginSelectedCirclev - selectedRect.size.height * 0.5)
        
        CGPathMoveToPoint(trianglePathM, nil, topX, topY)
        
        //添加左边点
        let leftPointX = topX - w * 0.5
        let leftPointY = topY + h
        CGPathAddLineToPoint(trianglePathM, nil, leftPointX, leftPointY)
        
        //右边的点
        let rightPointX = topX + w * 0.5
        CGPathAddLineToPoint(trianglePathM, nil, rightPointX, leftPointY)
        
        //将路径添加到上下文中
        CGContextAddPath(ctx, trianglePathM)
        
        //绘制圆环
        CGContextFillPath(ctx)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
