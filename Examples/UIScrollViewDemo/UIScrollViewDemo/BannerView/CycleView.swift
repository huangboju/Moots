//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class CycleView: UIView, UIScrollViewDelegate {
    // MARK: - 🍀 变量
    var scrollView: UIScrollView!
    var page = 0 // 当前处于的页面,默认为0

    private var imageViewX: CGFloat = 0

    var canCycle = true // 能否循环
    var canAutoRun: Bool = true { // 能否自动滑动
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
                if scrollView.contentOffset.x < scrollView.frame.width / 2 && ((data.count - 2) >= 0) {
                    scrollView.contentOffset.x = scrollView.frame.width * CGFloat(data.count - 2) + scrollView.contentOffset.x
                }
            } else if page >= data.count - 1 {
                scrollView.contentOffset.x = scrollView.frame.width
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timerInit()
    }
    
    var data: [String]!
    
    func set(contents: [String]) {
        data = [contents[0]] + contents + [contents[contents.count - 1]]
        let width = scrollView.frame.width
        
        scrollView.contentSize = CGSize(width: width * CGFloat(data.count), height: scrollView.frame.height)
        
        for (i, _) in data.enumerated() {
            let contentLabel = UILabel(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: scrollView.frame.height))
            contentLabel.text = i.description
            contentLabel.font = UIFont.systemFont(ofSize: 58)
            contentLabel.textAlignment = .center
            contentLabel.textColor = .white
            contentLabel.backgroundColor = UIColor(white: CGFloat(i) / 10, alpha: 1)
            contentLabel.tag = i
            scrollView.addSubview(contentLabel)
        }
        timerInit()
    }

    func timerInit() {
        if canAutoRun {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(autoSetCurrentContentOffset), userInfo: nil, repeats: true)
        }
    }

    func autoSetCurrentContentOffset() {
        let n = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let x = CGFloat(n) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: x + scrollView.frame.width, y: scrollView.contentOffset.y), animated: true)
    }
}
