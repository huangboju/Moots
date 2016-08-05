//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

enum NavigationBarDrawerState {
    case Hidden
    case Showing
    case Shown
    case Hiding
}

class NavigationBarDrawer: UIToolbar {
    var scrollView: UIScrollView?
    var visible: Bool? {
        return state != .Hidden
    }
    private var state = NavigationBarDrawerState.Hidden
    private var parentBar: UINavigationBar?
    private var verticalDrawerConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    convenience init() {
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44)))
    }
    
    func setUp() {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        let views = ["line" : lineView]
        let metrics = ["width" : 1 / UIScreen.mainScreen().scale]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[line]|", options: .AlignAllLeft, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(width)]|", options: .AlignAllLeft, metrics: metrics, views: views))
        translatesAutoresizingMaskIntoConstraints = false
        state = .Hidden
    }
    
    func setupConstraintsWithNavigationBar(navigationBar: UINavigationBar) {
        var constraint: NSLayoutConstraint!
        constraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: navigationBar, attribute: .Left, multiplier: 1, constant: 0)
        self.superview?.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: navigationBar, attribute: .Right, multiplier: 1, constant: 0)
        self.superview?.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 44)
        addConstraint(constraint)
    }
    
    func constrainBehindNavigationBar(navigationBar: UINavigationBar) {
        if let verticalDrawerConstraint = verticalDrawerConstraint {
            self.superview?.removeConstraint(verticalDrawerConstraint)
        }
        verticalDrawerConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0)
        self.superview?.addConstraint(verticalDrawerConstraint!)
    }
    
    func constrainBelowNavigationBar(navigationBar: UINavigationBar) {
        if let verticalDrawerConstraint = verticalDrawerConstraint {
            self.superview?.removeConstraint(verticalDrawerConstraint)
        }
        verticalDrawerConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0)
        self.superview?.addConstraint(verticalDrawerConstraint!)
    }
    
    func showFromNavigationBar(controller: UINavigationController?, _ animated: Bool) {
        guard let navigationBar = controller?.navigationBar else {
            print("Cannot display navigation bar from nil.")
            return
        }
        navigationBar.hideBottomHairline()
        if state == .Shown || state == .Showing {
            print("BFNavigationBarDrawer: Inconsistency warning. Drawer is already showing or is shown.")
            hideAnimated(false)
        }
        
        parentBar = navigationBar
        
        navigationBar.superview?.insertSubview(self, belowSubview: navigationBar)
        setupConstraintsWithNavigationBar(navigationBar)
        
        if animated && state == .Hidden {
            constrainBehindNavigationBar(navigationBar)
        }
        self.superview?.layoutIfNeeded()
        
        let height = frame.height
        if let scrollView = scrollView {
            let visible = scrollView.bounds.height - scrollView.contentInset.top - scrollView.contentInset.bottom
            let diff = visible - scrollView.contentSize.height
            let fix = max(0, min(height, diff))
            
            var insets = scrollView.contentInset
            insets.top += height
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + fix)
            
            constrainBelowNavigationBar(navigationBar)
            let animations = {
                self.state = .Showing
                self.superview?.layoutIfNeeded()
                self.scrollView?.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y - height)
            }
            
            let completion = { (flag: Bool) in
                if self.state == .Showing {
                    self.state = .Shown
                }
            }
            
            if animated {
                UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState , animations: animations, completion: completion)
            } else {
                animations()
                completion(true)
            }
        }
    }
    
    func hideAnimated(animated: Bool) {
        if state == .Hiding || state == .Hidden {
            print("BFNavigationBarDrawer: Inconsistency warning. Drawer is already hiding or is hidden.")
            return
        }
        
        guard let parentBar = parentBar else {
            print("BFNavigationBarDrawer: Navigation bar should not be released while drawer is visible.")
            return
        }
        
        let height = frame.height
        if let scrollView = scrollView {
            let visible = scrollView.bounds.height - scrollView.contentInset.top - scrollView.contentInset.bottom
            var fix = height
            if visible <= scrollView.contentSize.height - height {
                let bottom = -scrollView.contentOffset.y + scrollView.contentSize.height
                let diff = bottom - scrollView.bounds.height + scrollView.contentInset.bottom
                fix = max(0, min(height, diff))
            }
            let offset = height - (scrollView.contentOffset.y + scrollView.contentInset.top)
            let topFix = max(0, min(height, offset
                ))
            var insets = scrollView.contentInset
            insets.top -= height
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y - topFix)
            constrainBehindNavigationBar(parentBar)
            
            let animations = {
                self.state = .Hiding
                self.superview?.layoutIfNeeded()
                self.scrollView?.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + fix)
            }
            
            let completion = { (flag: Bool) in
                if self.state == .Hiding {
                    parentBar.showBottomHairline()
                    self.parentBar = nil
                    self.removeFromSuperview()
                    self.state = .Hidden
                }
            }
            
            if animated {
                UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState , animations: animations, completion: completion)
            } else {
                animations()
                completion(true)
            }
        }
    }
}

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as? UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as? UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView = hairlineImageViewInToolbar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}
