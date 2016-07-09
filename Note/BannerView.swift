//
//  Copyright © 2016年 chuchengpeng. All rights reserved.
//

import UIKit

enum BannerViewStyle {
    case Landscape, Portait
}

enum PageStyle {
    case None, Left, Right, Middle
}

protocol BannerViewDelegate {
    func bannerViewDidSelected(bannerView: BannerView,index: Int)
}

extension BannerViewDelegate {
    func bannerViewDidClosed(bannerView: BannerView) {}
}

class BannerView: UIView, UIScrollViewDelegate {
    var delegate: BannerViewDelegate?
    var scrollStyle: BannerViewStyle?
    var scrollTime: NSTimeInterval = 3
    var imagesArr = [String]()
    private var pageController: UIPageControl?
    private var enableScroll: Bool?
    private var scrollView: UIScrollView?
    private var closeButton: UIButton?
    private var totalPage = 0
    private var currentPage = 0
    private let pageControllerSize = CGSize(width: 60, height: 15)
    
    var normalColor: UIColor? {
        //给normalColor赋值后进行
        didSet {
            pageController?.pageIndicatorTintColor = oldValue
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            pageController?.currentPageIndicatorTintColor = oldValue
        }
    }
    
    //调用上面函数必须调用此函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //反初始化（析构函数）
    deinit {
        delegate = nil
    }
    
    //补充初始化（并不能被子类super）
    init(frame: CGRect,direction: BannerViewStyle, images: [String]) {
        //必须调用构造函数
        super.init(frame: frame)
        clipsToBounds = true
        imagesArr = images
        scrollStyle = direction
        totalPage = images.count
        currentPage = 1
        scrollView = UIScrollView(frame: bounds)
        scrollView?.backgroundColor = UIColor.clearColor()
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        addSubview(scrollView!)
        
        if scrollStyle == .Landscape {
            scrollView?.contentSize = CGSize(width: bounds.width * 3, height: bounds.height)
        } else if scrollStyle == .Portait {
            scrollView?.contentSize = CGSize(width: bounds.width, height: bounds.height * 3)
        }
        
        for i in 0 ..< 3 {
            let imageView = UIImageView(frame: bounds)
            imageView.userInteractionEnabled = true
            imageView.tag = 100 + i
            let singleTap = UITapGestureRecognizer(target: self,action: #selector(tapAction))
            imageView.addGestureRecognizer(singleTap)
            if scrollStyle == .Landscape {
                imageView.frame = CGRectOffset(imageView.frame, bounds.width * CGFloat(i), 0)
            } else if scrollStyle == .Portait {
                imageView.frame = CGRectOffset(imageView.frame, 0, bounds.height * CGFloat(i))
            }
            scrollView?.addSubview(imageView)
            if images.count >= 3 {
                imageView.image = UIImage(named: images[i])
            }
        }
        
        
        pageController = UIPageControl(frame: CGRect(origin: CGPoint(x: 5, y: bounds.height - pageControllerSize.height), size: pageControllerSize))
        pageController?.numberOfPages = images.count
        pageController?.currentPage = 0
        if let pageController = pageController {
            addSubview(pageController)
        }
    }
    
    //tap点击事件
    func tapAction(tap: UITapGestureRecognizer) {
        delegate?.bannerViewDidSelected(self, index: currentPage - 1)
    }
    
    func startScolling() {
        if imagesArr.count == 1 {
            return
        }
        stopScrolling()
        enableScroll = true
        performSelector(#selector(scrollingAction), withObject: nil, afterDelay: scrollTime)
    }
    
    func stopScrolling() {
        enableScroll = false
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(scrollingAction), object: nil)
    }
    
    private func getPageIndex(index: Int) -> Int {
        var pageIndex = index
        if index == 0 {
            pageIndex = totalPage
        }
        if index == totalPage + 1 {
            pageIndex = 1
        }
        return pageIndex
    }
    
    private func refreshScrollView() {
        let images = getImagesWithPageIndex(currentPage)
        for i in 0 ..< 3 {
            let imageView = scrollView?.viewWithTag(100 + i) as? UIImageView
            let imageName = images[i]
            imageView?.image = UIImage(named: imageName ?? "")
        }
        
        if scrollStyle == .Landscape {
            scrollView?.contentOffset = CGPoint(x: bounds.width, y: 0)
        } else if scrollStyle == .Portait {
            scrollView?.contentOffset = CGPoint(x: 0, y: bounds.height)
        }
        pageController?.currentPage = currentPage - 1
    }
    
    private func getImagesWithPageIndex(pageIndex: Int) -> [String] {
        let pre = getPageIndex(currentPage - 1)
        let last = getPageIndex(currentPage + 1)
        var images = [String]()
        images.append(imagesArr[pre - 1])
        images.append(imagesArr[currentPage - 1])
        images.append(imagesArr[last - 1])
        return images
    }
    
    func scrollingAction() {
        UIView.animateWithDuration(0.25, animations: { 
            if self.scrollStyle == .Landscape {
                self.scrollView?.contentOffset = CGPoint(x: self.bounds.width * 1.99, y: 0)
            } else if self.scrollStyle == .Portait {
                self.scrollView?.contentOffset = CGPoint(x: 0, y: 1.99 * self.bounds.height)
            }
        }) { (finished) in
            if finished {
                self.currentPage = self.getPageIndex(self.currentPage + 1)
                self.refreshScrollView()
                if self.enableScroll != nil {
                    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
                    self.performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: self.scrollTime, inModes: [NSRunLoopCommonModes])
                }
            }
        }
    }
    
    func setSquare(asquare: CGFloat) {
        if let scrollView = scrollView {
            scrollView.layer.cornerRadius = asquare
            scrollView.layer.masksToBounds = asquare != 0
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        if enableScroll != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(scrollingAction), object: nil)
        }
        if scrollStyle == .Landscape   {
            if x >= bounds.width * 2 {
                currentPage = getPageIndex(currentPage + 1)
                refreshScrollView()
            }
            if x <= 0 {
                currentPage = getPageIndex(currentPage - 1)
                refreshScrollView()
            }
        } else if scrollStyle == .Portait {
            if  y >= bounds.height * 2 {
                currentPage = getPageIndex(currentPage + 1)
                refreshScrollView()
            }
            if y <= 0 {
                currentPage = getPageIndex(currentPage - 1)
                refreshScrollView()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollStyle == .Landscape {
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        } else if scrollStyle == .Portait {
            scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
        }
        
        if enableScroll != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(scrollingAction), object: nil)
            performSelector(#selector(scrollingAction), withObject: nil, afterDelay: scrollTime, inModes: [NSRunLoopCommonModes])
        }
    }
    
    func setPageControlStyle(pageStyle: PageStyle) {
        if pageStyle == .Left {
            pageController?.frame.origin = CGPoint(x: 5, y: bounds.height - pageControllerSize.height)
        } else if pageStyle == .Right {
            pageController?.frame.origin = CGPoint(x: bounds.width - pageControllerSize.width, y: bounds.height - pageControllerSize.height)
        } else if pageStyle == .Middle {
            pageController?.frame.origin = CGPoint(x: (bounds.width - pageControllerSize.width) / 2, y: bounds.height - pageControllerSize.height)
        } else if pageStyle == .None {
            pageController?.hidden = true
        }
    }
}
