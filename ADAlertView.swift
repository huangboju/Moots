//
//  Copyright © 2016 cmcaifu.com. All rights reserved.
//

//MARK: - ADAlertCloseButton
class ADAlertCloseButton: UIButton {
    var buttonStrokeColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        let buttonWidth = min(CGRectGetWidth(rect), CGRectGetHeight(rect))
        let radius = buttonWidth / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        let contex = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(contex, buttonStrokeColor!.CGColor)
        CGContextSetLineWidth(contex, 2)
        
        CGContextBeginPath(contex)
        
        let path = UIBezierPath(roundedRect: CGRectInset(rect, 1, 1), cornerRadius: radius).CGPath
        
        CGContextAddPath(contex, path)
        
        CGContextMoveToPoint(contex, 0, 0)
        CGContextAddLineToPoint(contex, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        
        CGContextMoveToPoint(contex, CGRectGetMaxX(rect), 0)
        CGContextAddLineToPoint(contex, 0, CGRectGetMaxY(rect))
        
        CGContextStrokePath(contex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ADAlertContainerView
class ADAlertContainerView: UIView {
    var cornerRadius: CGFloat?
    var containerBgColor: UIColor?
    var closeBtnTintColor: UIColor?
    var closeBtnBgColor: UIColor?
    var containtViews = [UIView]()
    
    private let closeBtn = ADAlertCloseButton()
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.backgroundColor = .redColor()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        closeBtn.buttonStrokeColor = closeBtnTintColor
        closeBtn.backgroundColor = closeBtnBgColor
        closeBtn.addTarget(self.superview, action: #selector(ADAlertView().hide), forControlEvents: .TouchUpInside)
        
        if let cornerRadius = self.cornerRadius {
            containerView.layer.cornerRadius = cornerRadius
        }
        
        containerView.backgroundColor = containerBgColor
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(scrollView)
        
        addSubview(containerView)
        addSubview(closeBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let kContainerPadding: CGFloat = 5
        let kCloseButtonWidth: CGFloat = 32
        
        let subviewCount = CGFloat(containtViews.count)
        
        let containerFrame = CGRectInset(bounds, kContainerPadding, kContainerPadding)
        containerView.frame = containerFrame
        containerView.layer.cornerRadius = cornerRadius!
        containerView.backgroundColor = containerBgColor
        
        closeBtn.buttonStrokeColor = closeBtnTintColor
        closeBtn.backgroundColor = closeBtnBgColor
        closeBtn.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(kCloseButtonWidth, kCloseButtonWidth))
        closeBtn.center = CGPointMake(CGRectGetMaxX(containerView.frame) - kCloseButtonWidth / 4.5, CGRectGetMinY(containerView.frame) + kCloseButtonWidth / 4.5)
        closeBtn.setNeedsDisplay()
        
        scrollView.frame = CGRectInset(containerView.bounds, 5, 5)
        
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame) * subviewCount, CGRectGetHeight(scrollView.frame))
        
        scrollView.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        
        for idx in 0..<Int(subviewCount) {
            let viewToAdd = containtViews[idx]
            viewToAdd.frame = CGRectMake(CGFloat(idx) * CGRectGetWidth(scrollView.frame), 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame))
            scrollView.addSubview(viewToAdd)
        }
        scrollView.contentOffset = CGPointZero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ADAlertView: UIView {
    var cardBgColor: UIColor?
    var closeBtnTintColor: UIColor?
    var closeBtnBgColor: UIColor?
    var cornerRadius: CGFloat?
    var dimBackground: Bool?
    var containerSubviews = [UIView]() {
        didSet {
            if NSThread.isMainThread() {
                performSelectorOnMainThread(#selector(updateUIForKeypath), withObject: "containerSubviews", waitUntilDone: false)
            } else {
                updateUIForKeypath("containerSubviews")
            }
        }
    }
    var minHorizontalPadding: CGFloat?
    var minVertalPadding: CGFloat?
    var proportion: CGFloat?
    
    private let containerView = ADAlertContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        
        backgroundColor = .clearColor()
        
        cardBgColor = .whiteColor()
        closeBtnTintColor = UIColor(red: 0, green: 183 / 255, blue: 238 / 255, alpha: 1)
        closeBtnBgColor = .whiteColor()
        cornerRadius = 10
        dimBackground = true
        minHorizontalPadding = 25
        minVertalPadding = 10
        
        proportion = 0.75
        addSubview(containerView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(statusBarOrientationDidChange), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    convenience init () {
        self.init(frame: CGRectZero)
    }
    
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }
    
    convenience init(window: UIWindow) {
        self.init(view: window)
    }
    
    deinit {
        for keyPath in observableKeypaths() {
            removeObserver(self, forKeyPath: keyPath)
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    func show() {
        showUsingAnimation(true)
    }
    
    func hide() {
        hideUsingAnimation(true)
    }
    
    func showUsingAnimation(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                self.alpha = 1
            })
        } else {
            alpha = 1
        }
    }
    
    func hideUsingAnimation(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                self.alpha = 0
            })
        } else {
            alpha = 0
        }
    }
    
    func observableKeypaths() -> [String] {
        return ["containerSubviews", "cardBgColor", "closeBtnTintColor", "closeBtnBgColor", "cornerRadius", "dimBackground", "minHorizontalPadding", "minVertalPadding", "proportion"]
    }
    
    func updateUIForKeypath(keyPath: String) {
        if keyPath == "containerSubviews" {
            containerView.containtViews = containerSubviews
        }
        
        setNeedsLayout()
        setNeedsDisplay()
        
        for subView in subviews {
            subView.setNeedsLayout()
            subView.setNeedsDisplay()
        }
    }
    
    func statusBarOrientationDidChange(notification: NSNotification) {
        if let superview = self.superview {
            frame = superview.bounds
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if dimBackground! {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, UIColor(red: 0, green: 0, blue: 0, alpha: 0.65).CGColor)
            CGContextFillRect(context, rect)
        }
    }
    
    override func layoutSubviews() {
        let kWidthPadding = minHorizontalPadding
        let kHeightPadding = minVertalPadding
        
        let kProportion = proportion
        
        containerView.containerBgColor = cardBgColor
        containerView.closeBtnBgColor = closeBtnBgColor
        containerView.closeBtnTintColor = closeBtnTintColor
        containerView.cornerRadius = cornerRadius
        
        if CGRectGetWidth(bounds) > CGRectGetHeight(bounds) {
            let containerHeight = CGRectGetHeight(bounds) - kHeightPadding! * 2
            containerView.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(containerHeight * kProportion!, containerHeight))
        } else {
            let containerWidth = CGRectGetWidth(bounds) - kWidthPadding! * 2
            containerView.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(containerWidth, containerWidth / kProportion!))
        }
        
        containerView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
