//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class PageCell: UIView, UIScrollViewDelegate {
    // MARK: - 🍀 变量
    var scrollView: UIScrollView!
    var count = 0
    var page = 0 // 当前处于的页面,默认为0

    private var imageViewX: CGFloat = 0

    var canCycle = false // 能否循环
    var canAutoRun: Bool = false { // 能否自动滑动
        didSet {
            if canAutoRun {
                timerInit()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    var timer: Timer? // 计时器(用来控制自动滑动)

    // MARK: - 💖 初始化
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false // 这句和下一句可以让点击响应到父类 ＃SO
        addGestureRecognizer(scrollView.panGestureRecognizer)
        addSubview(scrollView)
        scrollView.delegate = self
    }

    // MARK: - 💜 UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if canAutoRun {
            // 计时器 inValidate
            timer?.invalidate()
            timer = nil
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if canCycle {
            if page <= 0 {
                if scrollView.contentOffset.x < scrollView.frame.width / 2 && ((count - 2) >= 0) {
                    scrollView.contentOffset.x = scrollView.frame.width * CGFloat(count - 2) + scrollView.contentOffset.x
                }
            } else if page >= count - 1 {
                scrollView.contentOffset.x = scrollView.frame.width
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timerInit()
    }

    // MARK: - 💛 自定义方法 (Custom Method)
    func addPage(view: UIView) {
        count += 1
        view.tag = count
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(count), height: scrollView.frame.height)
        scrollView.addSubview(view)
    }

    func timerInit() {
        if canAutoRun {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoSetCurrentContentOffset), userInfo: nil, repeats: true)
        }
    }

    func autoSetCurrentContentOffset() {
        let n = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let x = CGFloat(n) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: x + scrollView.frame.width, y: scrollView.contentOffset.y), animated: true)
    }
}
