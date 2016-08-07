//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class SphereMenu: UIView, UICollisionBehaviorDelegate {
    typealias selected = (Int) -> Void
    
    var angle: CGFloat!
    var sphereDamping: CGFloat!
    var sphereLength: CGFloat!
    
    private let kItemInitTag = 1571
    private let kAngleOffset = CGFloat(M_PI_4)
    private let kSphereLength: CGFloat = 80
    private let kSphereDamping: CGFloat = 0.3
    
    private var count: Int!
    private var startImageView: UIImageView!
    private var startLabel: UILabel!
    private var images: [UIImage]?
    private var items = [UIDynamicItem]()
    private var positions = [NSValue]()
    
    private var animator: UIDynamicAnimator?
    private var collision: UICollisionBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    private var snaps = [UISnapBehavior]()
    private var tapOnStart: UITapGestureRecognizer!
    private var bumper: UIDynamicItem!
    private var expanded = false
    private var selectedItem: selected?
    
    init(startPoint: CGPoint, startViewSize: CGSize, submenuImages: [UIImage], handle: selected?) {
        super.init(frame: CGRect.zero)
        bounds = CGRect(origin: CGPoint.zero, size: startViewSize)
        
        startLabel = UILabel(frame: bounds)
        startLabel.backgroundColor = .redColor()
        startLabel.layer.cornerRadius = bounds.width / 2
        startLabel.clipsToBounds = true
        startLabel.userInteractionEnabled = true
        startLabel.textColor = .whiteColor()
        startLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        startLabel.textAlignment = .Center
        
        prepare(submenuImages, startPoint: startPoint, isImageView: false, handle: handle)
        addSubview(startLabel)
    }
    
    init(startPoint: CGPoint, startImage: UIImage, submenuImages: [UIImage], handle: selected?) {
        super.init(frame: CGRect.zero)
        bounds = CGRect(origin: CGPoint.zero, size: startImage.size)
        
        startImageView = UIImageView(image: startImage)
        startImageView.userInteractionEnabled = true
        
        prepare(submenuImages, startPoint: startPoint, isImageView: true, handle: handle)
        addSubview(startImageView)
    }
    
    private func prepare(images: [UIImage], startPoint: CGPoint, isImageView: Bool, handle: selected?) {
        center = startPoint
        
        selectedItem = handle
        
        self.images = images
        count = images.count
        angle = kAngleOffset
        sphereLength = kSphereLength
        sphereDamping = kSphereDamping
        
        tapOnStart = UITapGestureRecognizer(target: self, action: #selector(startTapped))
        if isImageView {
            startImageView.addGestureRecognizer(tapOnStart)
        } else {
            startLabel.addGestureRecognizer(tapOnStart)
        }
    }
    
    func commonSetup() {
        for i in 0..<count {
            let item = UIImageView(image: images![i])
            item.tag = kItemInitTag + i
            item.userInteractionEnabled = true
            superview?.addSubview(item)
            
            let position = centerForSphereAtIndex(i)
            item.center = center
            positions.append(NSValue(CGPoint: position))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            item.addGestureRecognizer(tap)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
            item.addGestureRecognizer(pan)
            
            items.append(item)
        }
        
        superview?.bringSubviewToFront(self)
        
        animator = UIDynamicAnimator(referenceView: superview!)
        
        collision = UICollisionBehavior(items: items)
        collision?.translatesReferenceBoundsIntoBoundary = true
        collision?.collisionDelegate = self
        
        for i in 0..<count {
            let snap = UISnapBehavior(item: items[i], snapToPoint: center)
            snap.damping = sphereDamping
            snaps.append(snap)
        }
        
        itemBehavior = UIDynamicItemBehavior(items: items)
        itemBehavior?.allowsRotation = false
        itemBehavior?.elasticity = 1.2
        itemBehavior?.density = 0.5
        itemBehavior?.angularResistance = 5
        itemBehavior?.resistance = 10
        itemBehavior?.elasticity = 0.8
        itemBehavior?.friction = 0.5
    }
    
    override func didMoveToSuperview() {
        commonSetup()
    }
    
    func centerForSphereAtIndex(index: Int) -> CGPoint {
        let firstAngle = CGFloat(M_PI) + (CGFloat(M_PI_2) - angle) + CGFloat(index) * angle
        let startPoint = center
        let x = startPoint.x + cos(firstAngle) * sphereLength
        let y = startPoint.y + sin(firstAngle) * sphereLength
        
        return CGPoint(x: x,y: y)
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let selectedItem =  self.selectedItem {
            var tag = gesture.view?.tag
            tag! -= kItemInitTag
            selectedItem(tag!)
        }
        shrinkSubmenu()
    }
    
    func startTapped(gesture: UITapGestureRecognizer) {
        animator?.removeBehavior(collision)
        animator?.removeBehavior(itemBehavior)
        removeSnapBehaviors()
        
        if expanded {
            shrinkSubmenu()
        } else {
            expandSubmenu()
        }
    }
    
    func expandSubmenu() {
        for i in 0..<count {
            snapToPostionsWithIndex(i)
        }
        
        expanded = true
    }
    
    func shrinkSubmenu() {
        animator?.removeBehavior(collision)
        
        for i in 0..<count {
            snapToStartWithIndex(i)
        }
        expanded = false
    }
    
    func panned(gesture: UIPanGestureRecognizer) {
        let touchedView = gesture.view
        if gesture.state == .Began {
            animator?.removeBehavior(itemBehavior)
            animator?.removeBehavior(collision)
            removeSnapBehaviors()
        } else if gesture.state == .Changed {
            touchedView?.center = gesture.locationInView(superview)
        } else if gesture.state == .Ended {
            bumper = touchedView
            animator?.addBehavior(collision)
            
            let index = items.indexOf{$0 as! NSObject == touchedView!}
            
            if let idx = index {
                snapToPostionsWithIndex(idx)
            }
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        animator?.addBehavior(itemBehavior)
        
        if !item1.isEqual(bumper) {
            let index = items.indexOf({$0 as! String == item1 as! String})
            if let idx = index {
                snapToPostionsWithIndex(idx)
            }
        }
        
        if !item2.isEqual(bumper) {
            let index = items.indexOf({$0 as! String == item2 as! String})
            if let idx = index {
                snapToPostionsWithIndex(idx)
            }
        }
    }
    
    func snapToStartWithIndex(index: Int) {
        let snap = UISnapBehavior(item: items[index], snapToPoint: center)
        snap.damping = sphereDamping
        let snapToRemove = snaps[index]
        snaps[index] = snap
        animator?.removeBehavior(snapToRemove)
        animator?.addBehavior(snap)
    }
    
    func snapToPostionsWithIndex(index: Int) {
        let positionValue = positions[index]
        let position = positionValue.CGPointValue()
        let snap = UISnapBehavior(item: items[index], snapToPoint: position)
        snap.damping = sphereDamping
        let snapToRemove = snaps[index]
        snaps[index] = snap
        animator?.removeBehavior(snapToRemove)
        animator?.addBehavior(snap)
    }
    
    func removeSnapBehaviors() {
        snaps.forEach { (snap) in
            animator?.removeBehavior(snap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
