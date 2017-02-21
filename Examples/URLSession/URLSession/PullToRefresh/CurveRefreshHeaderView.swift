//
//  CurveRefreshHeaderView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

typealias RefreshingBlock = () -> ()
class CurveRefreshHeaderView: CurveRefreshView {

    override func progressDidSet() {
        center = CGPoint(x: center.x, y: -fabs(associatedScrollView.contentOffset.y + originOffset) / 2)

        let diff = fabs(associatedScrollView.contentOffset.y + originOffset) - pullDistance + 10

        if diff > 0 {
            if !associatedScrollView.isTracking && !notTracking {
                notTracking = true
                loading = true

                // 旋转...
                curveView.startInfiniteRotation()
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.associatedScrollView.contentInset.top = strongSelf.pullDistance + strongSelf.originOffset
                }, completion: { [weak self](_) in
                    self?.refreshingBlock?()
                })
            }

            if !loading {
                curveView.transform = CGAffineTransform(rotationAngle: .pi * (diff * 90))
            }
        } else {
            labelView.loading = false
            curveView.transform = .identity
        }
    }

    override func initialize() {
        self.tag = 12580
        associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }

    func triggerPulling() {
        associatedScrollView.setContentOffset(CGPoint(x: 0, y: -pullDistance - originOffset), animated: true)
    }
}

// MARK: KVO

extension CurveRefreshHeaderView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else {
            return
        }

        guard let contentOffset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue else {
            return
        }

        if contentOffset.y + originOffset <= 0 {
            progress = max(0.0, min(fabs(contentOffset.y + originOffset) / pullDistance, 1.0))
        }
    }
}
