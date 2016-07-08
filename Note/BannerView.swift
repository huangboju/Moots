//
//  Copyright © 2016年 chuchengpeng. All rights reserved.
//

import UIKit

/*
 滚动方向
 *水平
 *数值
 */
enum BannerViewStyle {
    case Landscape, Portait
}

/*
 pageControl显示位置
 *不显示
 *显示在左边
 *显示在右边
 *显示在中间
 */
enum PageStyle {
    case None, Left, Right, Middle
}

protocol BannerViewDelegate {
    func bannerViewDidSelected(bannerView: BannerView,index: Int)
    func bannerViewDidClosed(bannerView: BannerView)
}

class BannerView: UIView, UIScrollViewDelegate {
    var delegate: BannerViewDelegate?
    var imagesArr: NSArray?
    var scrollStyle: BannerViewStyle?
    var scrollTime: NSTimeInterval?
    private var totalCount: Int?
    private var pageController: UIPageControl?
    private var enableScroll: Bool?
    private var scrollView: UIScrollView?
    private var closeButton: UIButton?
    private var totalPage: Int?
    private var currentPage = 0
    
    var normalColor: UIColor? {
        //给normalColor赋值后进行
        didSet {
            pageController?.pageIndicatorTintColor = normalColor
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            pageController?.currentPageIndicatorTintColor = selectedColor
        }
    }
    
    //调用上面函数必须调用此函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //反初始化（析构函数）
    deinit {
        self.delegate = nil
    }
    
    //补充初始化（并不能被子类super）
    init(frame: CGRect,direction: BannerViewStyle, images: [String]) {
        //必须调用构造函数
        super.init(frame: frame)
        clipsToBounds = true
        imagesArr = images
        scrollStyle = direction
        totalPage = images.count
        totalCount = images.count
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
            }
            else if scrollStyle == .Portait {
                imageView.frame = CGRectOffset(imageView.frame, 0, bounds.height * CGFloat(i))
            }
            scrollView?.addSubview(imageView)
            if images.count >= 3 {
                imageView.image = UIImage(named: images[i])
            }
        }
        
        pageController = UIPageControl(frame: CGRectMake(5, frame.height - 15, 60, 15))
        pageController?.numberOfPages = images.count
        addSubview(pageController!)
        pageController?.currentPage = 0
    }
    
    //tap点击事件
    func tapAction(tap: UITapGestureRecognizer) {
        delegate?.bannerViewDidSelected(self, index: currentPage - 1)
    }
    
    func startScolling() {
        if imagesArr?.count == 1 {
            return
        }
        stopScrolling()
        enableScroll = true
        performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: scrollTime!)
    }
    
    func stopScrolling() {
        enableScroll = false
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
    }
    
    private func getPageIndex(index: Int) -> Int {
        var pageIndex = index
        if index == 0 {
            pageIndex = totalPage!
        }
        if index == totalPage! + 1 {
            pageIndex = 1
        }
        return pageIndex
    }
    
    private func refreshScrollView() {
        let images = self.getImagesWithPageIndex(currentPage)
        for i in 0 ..< 3 {
            let imageView = self.scrollView!.viewWithTag(100 + i) as! UIImageView
            let imageName = images[i] as! String
            imageView.image = UIImage(named: imageName)
        }
        
        if scrollStyle == BannerViewStyle.Landscape {
            scrollView?.contentOffset = CGPointMake(self.bounds.size.width, 0)
        }
        else if scrollStyle == BannerViewStyle.Portait {
            scrollView?.contentOffset = CGPointMake(0, self.bounds.size.height)
        }
        pageController?.currentPage = currentPage - 1
    }
    
    private func getImagesWithPageIndex(pageIndex: Int) -> NSArray {
        let pre = self.getPageIndex(currentPage - 1)
        let last = self.getPageIndex(currentPage + 1)
        let images = NSMutableArray.init(capacity: 0)
        images.addObject(imagesArr![pre - 1])
        images.addObject(imagesArr![currentPage - 1])
        images.addObject(imagesArr![last - 1])
        return images
    }
    
    func scrollingAction() {
        UIView.animateWithDuration(0.25, animations: { 
            if self.scrollStyle == BannerViewStyle.Landscape {
                self.scrollView?.contentOffset = CGPointMake(self.bounds.size.width * 1.99, 0)
            } else if self.scrollStyle == BannerViewStyle.Portait {
                self.scrollView?.contentOffset = CGPointMake(0, 1.99 * self.bounds.height)
            }
        }) { (finished: Bool) in
            if finished {
                self.currentPage = self.getPageIndex(currentPage + 1)
                self.refreshScrollView()
                if self.enableScroll != nil {
                    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
                    self.performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: self.scrollTime!, inModes: [NSRunLoopCommonModes])
                }
            }
        }
    }
    
    func setSquare(asquare: CGFloat) {
        if self.scrollView != nil {
            self.scrollView!.layer.cornerRadius = asquare
            if asquare == 0 {
                scrollView?.layer.masksToBounds = false
            }
            else {
                scrollView?.layer.masksToBounds = true
            }
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
                self.refreshScrollView()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollStyle == .Landscape {
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        }
        else if scrollStyle == BannerViewStyle.Portait {
            scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
        }
        
        if self.enableScroll != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(scrollingAction), object: nil)
            performSelector(#selector(scrollingAction), withObject: nil, afterDelay: scrollTime!, inModes: [NSRunLoopCommonModes])
        }
    }
    
    func setPageControlStyle(pageStyle: PageStyle) {
        if pageStyle == .Left {
            pageController?.frame = CGRectMake(5, bounds.height - 15, 60, 15)
        } else if pageStyle == .Right {
            pageController?.frame = CGRectMake(bounds.size.width - 60, self.bounds.size.height - 15, 60, 15)
        } else if pageStyle == .Middle {
            pageController?.frame = CGRectMake((bounds.width - 60)/2, bounds.height - 15, 60, 15)
        } else if pageStyle == .None {
            pageController?.hidden = true
        }
    }
}
