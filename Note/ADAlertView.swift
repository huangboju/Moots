//
//  Copyright © 2016 cmcaifu.com. All rights reserved.
//

//MARK: - ADAlertCloseButton
class ADAlertCloseButton: UIButton {
    var buttonStrokeColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func drawRect(rect: CGRect) {
        let buttonWidth = min(rect.width, rect.height)
        let radius = buttonWidth / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
        let contex = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(contex, UIColor.lightGrayColor().CGColor)
        CGContextSetLineWidth(contex, 1)
        CGContextBeginPath(contex)
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: radius).CGPath
        CGContextAddPath(contex, path)
        CGContextMoveToPoint(contex, 0, 0)
        CGContextAddLineToPoint(contex, rect.maxX, rect.maxY)
        CGContextMoveToPoint(contex, rect.maxX, 0)
        CGContextAddLineToPoint(contex, 0, rect.maxY)
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
    var contents = [UIImage]()

    private let kCloseButtonWidth: CGFloat = 24
    private let lengthen: CGFloat = 15
    private let closeBtn = ADAlertCloseButton()
    private let containerView = UIView()
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private var selectedIndexPath: ((NSIndexPath) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)


        collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ADCell.self, forCellWithReuseIdentifier: "cell_id")
        collectionView.backgroundColor = .clearColor()
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        closeBtn.buttonStrokeColor = closeBtnTintColor
        closeBtn.backgroundColor = .clearColor()
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
        containerView.frame = bounds

        closeBtn.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: kCloseButtonWidth, height: kCloseButtonWidth))
        closeBtn.frame.origin = CGPoint(x: (containerView.frame.maxX - kCloseButtonWidth) / 2, y: containerView.frame.maxY - kCloseButtonWidth)
        closeBtn.setNeedsDisplay()

        collectionView.frame = containerView.bounds.insetBy(dx: 0, dy: kCloseButtonWidth + lengthen)
        layout.itemSize = collectionView.frame.size

        collectionView.reloadData()
        collectionView.contentOffset = CGPoint.zero
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
        let adCell = cell as? ADCell
        adCell?.imageView.image = contents[indexPath.row]
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            selectedIndexPath(indexPath)
        }
    }

    func selected(item: ((NSIndexPath) -> Void)) {
        self.selectedIndexPath = item
    }
}

class ADCell: UICollectionViewCell {
    let imageView = UIImageView()
    let textLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleAspectFill
        clipsToBounds = true
        contentView.addSubview(imageView)

        textLabel.frame = CGRect(x: (frame.width - 40) / 2, y: 50, width: 40, height: 20)
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

    var containerSubviews = [UIImage]() {
        didSet {
            if NSThread.isMainThread() {
                performSelectorOnMainThread(#selector(updateUIForKeypath), withObject: nil, waitUntilDone: false)
            } else {
                updateUIForKeypath()
            }
        }
    }

    private var selectedIndexPath: ((NSIndexPath) -> Void)?
    private var closeAction: ((Bool) -> Void)?

    private let containerView = ADAlertContainerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0

        backgroundColor = .clearColor()

        //        cardBgColor = .whiteColor()
        closeBtnTintColor = .whiteColor()
        //        closeBtnBgColor = .whiteColor()
        cornerRadius = 10
        dimBackground = true
        minHorizontalPadding = frame.width * 0.1
        minVertalPadding = 10
        proportion = 0.75
        addSubview(containerView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(statusBarOrientationDidChange), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }

    convenience init () {
        self.init(frame: CGRect.zero)
    }

    convenience init(view: UIView, handle: ((NSIndexPath) -> Void)? = nil, close: ((Bool) -> Void)? = nil) {
        self.init(frame: view.bounds)
        view.addSubview(self)
        selectedIndexPath = handle
        closeAction = close
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
        if let close = self.closeAction {
            close(true)
        }
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

    func updateUIForKeypath() {
        containerView.contents = containerSubviews
        containerView.selected({ [unowned self] (indexPath) in
            if let selectedIndePath = self.selectedIndexPath {
                selectedIndePath(indexPath)
                self.hide()
            }
            })

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


    //layoutSubviews是调整自己子视图们的frame；而drawRect是创建自己的视图内容
    override func layoutSubviews() {
        let kWidthPadding = minHorizontalPadding
        let kHeightPadding = minVertalPadding

        let kProportion = proportion

        containerView.containerBgColor = cardBgColor
        containerView.closeBtnBgColor = closeBtnBgColor
        containerView.closeBtnTintColor = closeBtnTintColor
        containerView.cornerRadius = cornerRadius

        if bounds.width > bounds.height {
            let containerHeight = bounds.height - kHeightPadding! * 2
            containerView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: containerHeight * kProportion!, height: containerHeight))
        } else {
            let containerWidth = bounds.width - kWidthPadding! * 2
            containerView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: containerWidth, height: containerWidth / kProportion! + 78))
        }

        containerView.center = CGPoint(x: bounds.midX, y: bounds.midY - 39)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
