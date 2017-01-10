//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//


import UIKit
import Chameleon
import SnapKit

class PagingSecondController: UIViewController, UIScrollViewDelegate {
    
    let DIAMETER = UIScreen.main.bounds.width * 0.8
    let MARGIN: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        
        automaticallyAdjustsScrollViewInsets = false
        let touchView = TouchDelegateView()
        touchView.touchDelegateView = scrollView
        view.addSubview(touchView)
        touchView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view)
            make.width.equalTo(DIAMETER + MARGIN)
            make.centerX.equalTo(view)
        }
        scrollView.clipsToBounds = false
        scrollView.addSubview(contentView)
        
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let y = (scrollView.frame.height - (DIAMETER + MARGIN)) / 2
        scrollView.contentSize = CGSize(width: (DIAMETER + MARGIN) * 10, height: view.frame.height)
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView.contentSize.width)
            make.edges.equalTo(scrollView)
        }
        for i in 0..<10 {
            let x = MARGIN / 2 + CGFloat(i) * (DIAMETER + MARGIN)
            let frame = CGRect(x: x, y: y, width: DIAMETER, height: DIAMETER * 4 / 3)
            let imageView = UIImageView(frame: frame)
            imageView.backgroundColor = UIColor.flatBlue()
            imageView.layer.masksToBounds = true
            imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin]
            contentView.addSubview(imageView)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    func nearestTargetOffset(for offset: CGPoint) -> CGPoint {
        let pageSize: CGFloat = DIAMETER + MARGIN
        let page = roundf(Float(offset.x / pageSize))
        let targetX = pageSize * CGFloat(page)
        return CGPoint(x: targetX, y: offset.y)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = nearestTargetOffset(for: targetContentOffset.pointee)
        targetContentOffset.pointee.x = targetOffset.x
        targetContentOffset.pointee.y = targetOffset.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
