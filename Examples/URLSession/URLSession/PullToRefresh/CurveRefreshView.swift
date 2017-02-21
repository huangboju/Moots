//
//  CurveRefreshView.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CurveRefreshView: UIView {
    /// 需要滑动多大距离才能松开
    var pullDistance: CGFloat = 99
    /// 刷新执行的具体操作
    var refreshingBlock: RefreshingBlock?

    var associatedScrollView: UIScrollView!
    var labelView: LabelView!
    var curveView: CurveView!
    var originOffset: CGFloat = 0
    var willEnd = false
    var notTracking = false
    var loading = false

    var progress: CGFloat = 0.0 {
        didSet {
            if !associatedScrollView.isTracking {
                labelView.loading = true
            }
            
            if !willEnd && !loading {
                curveView.progress = progress
                labelView.progress = progress
            }
            
            progressDidSet()
        }
    }

    init(associatedScrollView: UIScrollView) {
        super.init(frame: CGRect(x: associatedScrollView.frame.width / 2 - 200 / 2, y: -100, width: 200, height: 100))
        let hasNavigationBar = associatedScrollView.viewController.navigationController?.navigationBar.isTranslucent ?? false

        originOffset = hasNavigationBar ? 64 : 0
        self.associatedScrollView = associatedScrollView

        curveView = CurveView(frame: CGRect(x: 20, y: 0, width: 30, height: frame.height))
        insertSubview(curveView, at: 0)
        labelView = LabelView(frame: CGRect(x: curveView.frame.minX + curveView.frame.width + 10.0, y: curveView.frame.minY, width: 150, height: curveView.frame.height))
        insertSubview(labelView, aboveSubview: curveView)

        initialize()
        associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        associatedScrollView.insertSubview(self, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {}
    
    func progressDidSet() {}
    
    func stopRefreshing() {
        willEnd = true
        progress = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(), animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0.0
            strongSelf.associatedScrollView.contentInset.top = strongSelf.originOffset
        }) { [weak self](finished) in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1.0
            strongSelf.willEnd = false
            strongSelf.notTracking = false
            strongSelf.loading = false
            strongSelf.labelView.loading = false
            strongSelf.curveView.stopInfiniteRotation()
        }
    }

    deinit {
        associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}

extension UIView {

    var viewController: UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }

    func startInfiniteRotation() {
        transform = CGAffineTransform.identity
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 0.5
        rotationAnimation.autoreverses = false
        rotationAnimation.repeatCount = HUGE
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopInfiniteRotation() {
        layer.removeAllAnimations()
    }
}
