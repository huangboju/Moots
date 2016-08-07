//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit
import PureLayout

enum VGParallaxHeaderMode {
    case Center, Fill, Top, TopFill
}

enum VGParallaxHeaderStickyViewPosition {
    case Bottom, Top
}

enum VGParallaxHeaderShadowBehaviour {
    case VHidden, Appearing, Disappearing, Always
}

var UIScrollViewVGParallaxHeader: String = "UIScrollViewVGParallaxHeader"

extension UIScrollView {
    
    func parallaxHeaderView(view: UIView, mode: VGParallaxHeaderMode, height: CGFloat, shadowBehaviour: VGParallaxHeaderShadowBehaviour) {
        parallaxHeaderView(view, mode: mode, height: height)
    }
    
    func parallaxHeaderView(view: UIView, mode: VGParallaxHeaderMode, height: CGFloat) {
        parallaxHeader = VGParallaxHeader(scrollView: self, contentView: view, mode: mode, height: height)
        
        parallaxHeader?.headerHeight = height
        
        shouldPositionParallaxHeader()
        
        // If UIScrollView adjust inset
        if !parallaxHeader!.insideTableView {
            var selfContentInset = contentInset
            selfContentInset.top += height
            
            contentInset = selfContentInset
            contentOffset = CGPoint(x: 0, y: -selfContentInset.top)
        }
        
        // Watch for inset changes
        addObserver(parallaxHeader!, forKeyPath: "contentInset", options: .New, context: nil)
    }
    
    func updateParallaxHeaderViewHeight(height: CGFloat) {
        var newContentInset: CGFloat = 0
        var selfContentInset = contentInset
        
        if height < parallaxHeader!.headerHeight {
            newContentInset = parallaxHeader!.headerHeight! - height;
            selfContentInset.top -= newContentInset
        } else {
            newContentInset = height - parallaxHeader!.headerHeight!
            selfContentInset.top += newContentInset
        }
        
        contentInset = selfContentInset
        contentOffset = CGPoint(x: 0, y: -selfContentInset.top)
        
        parallaxHeader?.headerHeight = height
        parallaxHeader?.setNeedsLayout()
    }
    
    func shouldPositionParallaxHeader() {
        if parallaxHeader!.insideTableView {
            positionTableViewParallaxHeader()
        } else {
            positionScrollViewParallaxHeader()
        }
    }
    
    func positionTableViewParallaxHeader() {
        let scaleProgress = fmaxf(0, (1 - (Float((contentOffset.y + parallaxHeader!.originalTopInset!) / parallaxHeader!.originalHeight!))))
        parallaxHeader!.progress = scaleProgress
        
        if contentOffset.y < parallaxHeader!.originalHeight {
            // We can move height to if here because its uitableview
            var height = -contentOffset.y + parallaxHeader!.originalHeight!
            // Im not 100% sure if this will only speed up VGParallaxHeaderModeCenter
            // but on other modes it can be visible. 0.5px
            if parallaxHeader!.mode! == .Center {
                height = round(height)
            }
            // This is where the magic is happening
            parallaxHeader!.containerView!.frame = CGRect(x: 0, y: contentOffset.y, width: frame.width, height: height)
        }
    }
    
    func positionScrollViewParallaxHeader() {
        let height = -contentOffset.y
        let scaleProgress = fmaxf(0, Float((height / (parallaxHeader!.originalHeight! + parallaxHeader!.originalTopInset!))))
        self.parallaxHeader!.progress = scaleProgress
        
        if contentOffset.y < 0 {
            // This is where the magic is happening
            parallaxHeader!.frame = CGRect(x: 0, y: contentOffset.y, width: frame.width, height: height)
        }
    }
    
    var parallaxHeader: VGParallaxHeader? {
        get {
            return (objc_getAssociatedObject(self, &UIScrollViewVGParallaxHeader) as? VGParallaxHeader)
        }
        
        set{
            // Remove All Subviews
            if self.subviews.count > 0 {
                for subview in subviews {
                    if subview.isMemberOfClass(VGParallaxHeader.self) {
                        subview.removeFromSuperview()
                    }
                }
            }
            
            newValue?.insideTableView = self.isKindOfClass(UITableView.self)
            
            // Add Parallax Header
            if newValue!.insideTableView {
                (self as! UITableView).tableHeaderView = newValue
                newValue?.setNeedsLayout()
            } else {
                addSubview(newValue!)
            }
            
            objc_setAssociatedObject(self, &UIScrollViewVGParallaxHeader, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

class VGParallaxHeader: UIView {
    var mode: VGParallaxHeaderMode?
    
    private var storeStickyViewPosition = VGParallaxHeaderStickyViewPosition.Top
    var stickyViewPosition: VGParallaxHeaderStickyViewPosition {
        set {
            storeStickyViewPosition = newValue
            updateStickyViewConstraints()
        }
        
        get {
            return storeStickyViewPosition
        }
    }
    
    private var storeStickyViewHeightConstraint = NSLayoutConstraint()
    var stickyViewHeightConstraint: NSLayoutConstraint {
        set {
            storeStickyViewHeightConstraint = newValue
            stickyView.removeConstraint(newValue)
            if self.stickyView.superview === self.containerView {
                self.stickyView.addConstraint(stickyViewHeightConstraint)
            }
        }
        
        get {
            return storeStickyViewHeightConstraint
        }
    }
    
    private var storeStickyView = UIView()
    var stickyView: UIView {
        set {
            storeStickyView = newValue
            storeStickyView.translatesAutoresizingMaskIntoConstraints = false
            containerView?.insertSubview(storeStickyView, aboveSubview: contentView!)
            updateStickyViewConstraints()
        }
        
        get {
            return storeStickyView
        }
    }
    
    var insideTableView = false
    var progress: Float?
    var shadowBehaviour: VGParallaxHeaderShadowBehaviour?
    
    var containerView: UIView?
    var contentView: UIView!
    
    var scrollView: UIScrollView?
    
    var originalTopInset: CGFloat!
    var originalHeight: CGFloat!
    
    var headerHeight: CGFloat?
    
    var insetAwarePositionConstraint: NSLayoutConstraint?
    var insetAwareSizeConstraint: NSLayoutConstraint?
    var stickyViewContraints: [NSLayoutConstraint]?
    
    init(scrollView: UIScrollView, contentView: UIView, mode: VGParallaxHeaderMode, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: height))
    
        self.mode = mode
        
        self.scrollView = scrollView
        
        originalHeight = height
        originalTopInset = scrollView.contentInset.top
        
        containerView = UIView(frame: bounds)
        containerView?.clipsToBounds = true
        
        if !insideTableView {
            containerView?.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            autoresizingMask = .FlexibleWidth
        }
        
        addSubview(containerView!)
        self.contentView = contentView
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        self.containerView?.addSubview(self.contentView!)
        setupContentViewMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func  setupContentViewMode() {
        switch mode! {
        case .Fill:
            addContentViewModeFillConstraints()
        case .Top:
            addContentViewModeTopConstraints()
        case .TopFill:
            addContentViewModeTopFillConstraints()
        case .Center:
            addContentViewModeCenterConstraints()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentInset" {
            let edgeInsets = change!["new"]?.UIEdgeInsetsValue()
            originalTopInset = edgeInsets!.top - (!insideTableView ? originalHeight! : 0)
            switch mode! {
            case .Fill:
                insetAwarePositionConstraint?.constant = originalTopInset / 2
                insetAwareSizeConstraint?.constant = -originalTopInset
            case .Top:
                insetAwarePositionConstraint?.constant = originalTopInset
            case .TopFill:
                insetAwarePositionConstraint?.constant = originalTopInset
                insetAwareSizeConstraint?.constant = -originalTopInset
            case .Center:
                insetAwarePositionConstraint?.constant = originalTopInset / 2
            }
            
            if !insideTableView {
                scrollView?.contentOffset = CGPoint(x: 0, y: -scrollView!.contentInset.top)
            }
            
            updateStickyViewConstraints()
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if (superview != nil && newSuperview == nil) {
            if superview!.respondsToSelector(Selector("contentInset")) {
                superview?.removeObserver(self, forKeyPath: "contentInset")
            }
        }
    }
    
    // MARK: - VGParallaxHeader (Auto Layout)
    func addContentViewModeFillConstraints() {
        contentView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        contentView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        insetAwarePositionConstraint = contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: containerView!, withOffset: originalTopInset! / 2)
        
        let constraint = contentView.autoSetDimension(.Height, toSize: originalHeight!, relation: .GreaterThanOrEqual)
        constraint.priority = UILayoutPriorityRequired
        
        insetAwareSizeConstraint = contentView.autoMatchDimension(.Height, toDimension: .Height, ofView: containerView!, withOffset: -originalTopInset!)
        
        insetAwareSizeConstraint?.priority = UILayoutPriorityDefaultHigh
    }
    
    func addContentViewModeTopConstraints() {
        let array = contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(originalTopInset!, 0, 0, 0), excludingEdge: .Bottom)
        insetAwarePositionConstraint = array.first
        
        contentView.autoSetDimension(.Height, toSize: originalHeight)
    }
    
    func addContentViewModeTopFillConstraints() {
        let array = contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: originalTopInset!, left: 0, bottom: 0, right: 0), excludingEdge: .Bottom)
        insetAwarePositionConstraint = array.first
        
        let constraint = contentView.autoSetDimension(.Height, toSize: originalHeight, relation: .GreaterThanOrEqual)
        constraint.priority = UILayoutPriorityRequired
        
        insetAwareSizeConstraint = contentView.autoMatchDimension(.Height, toDimension: .Height, ofView: containerView!, withOffset: -originalTopInset)
        
        insetAwareSizeConstraint?.priority = UILayoutPriorityDefaultHigh
    }
    
    func addContentViewModeCenterConstraints() {
        contentView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        contentView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        contentView.autoSetDimension(.Height, toSize: originalHeight)
        
        insetAwarePositionConstraint = contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: containerView!, withOffset: round(originalTopInset / 2))
    }
    
    
    // MARK: - VGParallaxHeader (Sticky View)
    func setStickyView(stickyView: UIView, height: CGFloat) {
        self.stickyView = stickyView
        stickyViewHeightConstraint = self.stickyView.autoSetDimension(.Height, toSize: height)
    }
    
    func updateStickyViewConstraints() {
        if let superview = stickyView.superview {
            if superview.isEqual(containerView) {
                var nonStickyEdge: ALEdge!
                switch stickyViewPosition {
                case .Top:
                    nonStickyEdge = .Bottom
                case .Bottom:
                    nonStickyEdge = .Top
                }
                
                // Remove Previous Constraints
                if let stickyViewContraints = stickyViewContraints {
                    stickyView.removeConstraints(stickyViewContraints)
                    containerView?.removeConstraints(stickyViewContraints)
                }
                
                // Add Constraints
                stickyViewContraints = stickyView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: originalTopInset, left: 0, bottom: 0, right: 0), excludingEdge: nonStickyEdge)
            }
        }
    }
}
