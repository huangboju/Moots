//
//  CurveRefreshFooterView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

class CurveRefreshFooterView: CurveRefreshView {

    override func progressDidSet(completion: @escaping(Bool) -> ()) {

        let diff = associatedScrollView.contentOffset.y - (associatedScrollView.contentSize.height - associatedScrollView.frame.height) - pullDistance // 控制刷新距离

        if diff > 0 {
            if !associatedScrollView.isTracking && !isHidden && !notTracking {
                notTracking = true
                loading = true

                // 旋转...
                curveView.startInfiniteRotation()
                UIView.animate(withDuration: 0.3, animations: { [weak self]() in
                    guard let strongSelf = self else { return }
                    strongSelf.associatedScrollView.contentInset.top = strongSelf.originOffset
                    strongSelf.associatedScrollView.contentInset.bottom = strongSelf.pullDistance
                }, completion: completion)
            }

            if !loading {
                curveView.transform = CGAffineTransform(rotationAngle: .pi * (diff * 2 / 180))
            }
        } else {
            labelView.loading = false
            curveView.transform = .identity
        }
    }

    fileprivate var contentSize: CGSize?

    override func initialize() {
        isHidden = true
        self.tag = 12581
        associatedScrollView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        labelView.state = .up
    }

    deinit {
        associatedScrollView.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: KVO

extension CurveRefreshFooterView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            guard let contentSize = (change?[.newKey] as AnyObject).cgSizeValue else {
                return
            }
            self.contentSize = contentSize
            isHidden = contentSize.height <= 0.0
            frame = CGRect(x: associatedScrollView.frame.width / 2 - 100, y: contentSize.height, width: 200, height: 100)
        } else if keyPath == "contentOffset" {
            guard let contentOffset = (change?[.newKey] as AnyObject).cgPointValue, let contentSize = contentSize else {
                return
            }
            let contentHight = contentSize.height
            let height = contentHight - associatedScrollView.frame.height
            if contentOffset.y >= height {
                center.y = contentHight + (contentOffset.y - height) / 2 - 16

                progress = max(0.0, min((contentOffset.y - height) / pullDistance, 1.0))
            }
        }
    }
}
