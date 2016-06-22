//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

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
            return (objc_getAssociatedObject(self, &UIScrollViewVGParallaxHeader) as? VGParallaxHeader)!
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
