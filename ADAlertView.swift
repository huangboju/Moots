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
class ADAlertContainerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var cornerRadius: CGFloat?
    var containerBgColor: UIColor?
    var closeBtnTintColor: UIColor?
    var closeBtnBgColor: UIColor?
    var contents = [String]()
    
    private let closeBtn = ADAlertCloseButton()
    private let containerView = UIView()
    private var collectionView: UICollectionView!
    private var selectedIndexPath: ((NSIndexPath) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ADCell.self, forCellWithReuseIdentifier: "cell_id")
        collectionView.backgroundColor = .redColor()
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        closeBtn.buttonStrokeColor = closeBtnTintColor
        closeBtn.backgroundColor = closeBtnBgColor
        closeBtn.addTarget(self.superview, action: #selector(ADAlertView().hide), forControlEvents: .TouchUpInside)
        
        if let cornerRadius = self.cornerRadius {
            containerView.layer.cornerRadius = cornerRadius
        }
        
        containerView.backgroundColor = containerBgColor
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(collectionView)
        
        addSubview(containerView)
        addSubview(closeBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let kContainerPadding: CGFloat = 5
        let kCloseButtonWidth: CGFloat = 32
        
        let containerFrame = CGRectInset(bounds, kContainerPadding, kContainerPadding)
        containerView.frame = containerFrame
        containerView.layer.cornerRadius = cornerRadius!
        containerView.backgroundColor = containerBgColor
        
        closeBtn.buttonStrokeColor = closeBtnTintColor
        closeBtn.backgroundColor = closeBtnBgColor
        closeBtn.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(kCloseButtonWidth, kCloseButtonWidth))
        closeBtn.center = CGPointMake(CGRectGetMaxX(containerView.frame) - kCloseButtonWidth / 4.5, CGRectGetMinY(containerView.frame) + kCloseButtonWidth / 4.5)
        closeBtn.setNeedsDisplay()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = CGRectInset(containerView.bounds, 5, 5).size
        layout.scrollDirection = .Horizontal
        collectionView.collectionViewLayout = layout
        collectionView.frame = CGRectInset(containerView.bounds, 5, 5)
        collectionView.reloadData()
        
        collectionView.contentOffset = CGPointZero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_id", forIndexPath: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let adCell = cell as! ADCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .yellowColor()
        } else {
            cell.backgroundColor = .whiteColor()
        }
        adCell.textLabel.text = "\(indexPath.row)"
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            selectedIndexPath(indexPath)
        }
    }
    
    func handle(item: ((NSIndexPath) -> Void)) {
        self.selectedIndexPath = item
    }
}

class ADCell: UICollectionViewCell {
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(origin: CGPointZero, size: frame.size)
        contentView.addSubview(imageView)
        
        textLabel.frame = CGRectMake((frame.width - 40) / 2, 50, 40, 20)
        textLabel.backgroundColor = .whiteColor()
        contentView.addSubview(textLabel)
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
    var minHorizontalPadding: CGFloat?
    var minVertalPadding: CGFloat?
    var proportion: CGFloat?
    
    var containerSubviews = [String]() {
        didSet {
            if NSThread.isMainThread() {
                performSelectorOnMainThread(#selector(updateUIForKeypath), withObject: "contents", waitUntilDone: false)
            } else {
                updateUIForKeypath("contents")
            }
        }
    }
    
    private var selectedIndePath: ((NSIndexPath) -> Void)?
    
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
    
    convenience init(view: UIView, handle: ((NSIndexPath) -> Void)? = nil) {
        self.init(frame: view.bounds)
        self.selectedIndePath = handle
    }
    
    convenience init(window: UIWindow) {
        self.init(view: window)
    }
    
    deinit {
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
    
    func updateUIForKeypath(keyPath: String) {
        if keyPath == "contents" {
            containerView.contents = containerSubviews
            containerView.handle({ [unowned self] (indexPath) in
                if let selectedIndePath = self.selectedIndePath {
                    selectedIndePath(indexPath)
                }
                })
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
