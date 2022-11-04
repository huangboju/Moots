//
//  EmbedScrollViewVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/9/23.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation


class EmbedScrollViewVC: UIViewController, UIScrollViewDelegate {

    var outerDeceleration: ConstantDisplayLinkAnimator?

    var nestedDeceleration: ConstantDisplayLinkAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(outerScrollView)

        outerScrollView.addSubview(nestedScrollView)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private lazy var statusBarHeight: CGFloat = {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }()

    var isNestedScrollEnabled: Bool {
        outerScrollView.contentOffset.y >= (300 - statusBarHeight - 44)
    }

    var isOuterEnable: Bool {
        nestedScrollView.contentOffset.y <= 0
    }

    var velocity: CGFloat = 0

    var velocityM1: CGFloat = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        velocityM1 = velocity
        velocity = scrollView.value(forKey: "_verticalVelocity") as? CGFloat ?? 0
        if scrollView == outerScrollView {
            if scrollView.contentOffset.y > 50 {
                if outerScrollView.bounces {
                    outerScrollView.bounces = false
                    outerScrollView.alwaysBounceVertical = false
                }
            } else {
                if !outerScrollView.bounces {
                    outerScrollView.bounces = true
                    outerScrollView.alwaysBounceVertical = true
                }
            }
            nestedScrollView.isScrollEnabled = isNestedScrollEnabled
        } else {
            if scrollView.contentOffset.y <= 0 {
                if nestedScrollView.bounces {
                    nestedScrollView.bounces = false
                    nestedScrollView.alwaysBounceVertical = false
                }
            } else {
                if !nestedScrollView.bounces {
                    nestedScrollView.bounces = true
                    nestedScrollView.alwaysBounceVertical = true
                }
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == outerScrollView {
            if let nestedDeceleration = nestedDeceleration {
                self.nestedDeceleration = nil
                nestedDeceleration.invalidate()
            }
        } else {
            if let outerDeceleration = outerDeceleration {
                self.outerDeceleration = nil
                outerDeceleration.invalidate()
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == outerScrollView {

        } else {

        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == outerScrollView {
            outerTransferVelocity(velocityM1)
        } else {
            nestedTransferVelocity(velocityM1)
        }
    }

    private lazy var outerScrollView: UIScrollView = {
        let outerScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        outerScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 300)
        outerScrollView.backgroundColor = .systemRed
        outerScrollView.contentInsetAdjustmentBehavior = .never
        outerScrollView.delegate = self
        return outerScrollView
    }()

    private lazy var nestedScrollView: UIScrollView = {
        let nestedScrollView = UIScrollView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height))
        nestedScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 3)
        nestedScrollView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        nestedScrollView.delegate = self
        nestedScrollView.isScrollEnabled = false
        nestedScrollView.delaysContentTouches = false
        nestedScrollView.contentInsetAdjustmentBehavior = .never
        nestedScrollView.addSubview(blockView)
        return nestedScrollView
    }()

    func outerTransferVelocity(_ velocity: CGFloat) {
        if velocity <= 0.0 {
            return
        }
        self.outerDeceleration?.isPaused = true
        let startTime = CACurrentMediaTime()
        var currentOffset = self.nestedScrollView.contentOffset
        let decelerationRate = nestedScrollView.decelerationRate.rawValue
        self.scrollViewDidEndDragging(self.nestedScrollView, willDecelerate: true)
        self.outerDeceleration = ConstantDisplayLinkAnimator(update: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let t = CACurrentMediaTime() - startTime
            var currentVelocity = velocity * 15.0 * CGFloat(pow(Double(decelerationRate), 1000.0 * t))
            currentOffset.y += currentVelocity
            let maxOffset = strongSelf.nestedScrollView.contentSize.height - strongSelf.nestedScrollView.bounds.height
            if currentOffset.y >= maxOffset {
                currentOffset.y = maxOffset
                currentVelocity = 0.0
            }
            if currentOffset.y < 0.0 {
                currentOffset.y = 0.0
                currentVelocity = 0.0
            }

            var didEnd = false
            if abs(currentVelocity) < 0.1 {
                strongSelf.outerDeceleration?.isPaused = true
                strongSelf.outerDeceleration = nil
                didEnd = true
            }
            var contentOffset = strongSelf.nestedScrollView.contentOffset
            contentOffset.y = currentOffset.y.flat
            strongSelf.nestedScrollView.setContentOffset(contentOffset, animated: false)
            strongSelf.scrollViewDidScroll(strongSelf.nestedScrollView)
            if didEnd {
                strongSelf.scrollViewDidEndDecelerating(strongSelf.nestedScrollView)
            }
        })
        self.outerDeceleration?.isPaused = false
    }

    func nestedTransferVelocity(_ velocity: CGFloat) {
        if velocity >= 0.0 {
            return
        }
        self.nestedDeceleration?.isPaused = true
        let startTime = CACurrentMediaTime()
        var currentOffset = self.outerScrollView.contentOffset
        let decelerationRate = outerScrollView.decelerationRate.rawValue
        self.scrollViewDidEndDragging(self.outerScrollView, willDecelerate: true)
        self.nestedDeceleration = ConstantDisplayLinkAnimator(update: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let t = CACurrentMediaTime() - startTime
            var currentVelocity = velocity * 15.0 * CGFloat(pow(Double(decelerationRate), 1000.0 * t))
            currentOffset.y += currentVelocity
            let maxOffset = strongSelf.outerScrollView.contentSize.height - strongSelf.outerScrollView.bounds.height
            if currentOffset.y >= maxOffset {
                currentOffset.y = maxOffset
                currentVelocity = 0.0
            }
            if currentOffset.y < 0.0 {
                currentOffset.y = 0.0
                currentVelocity = 0.0
            }

            var didEnd = false
            if abs(currentVelocity) < 0.1 {
                strongSelf.nestedDeceleration?.isPaused = true
                strongSelf.nestedDeceleration = nil
                didEnd = true
            }
            var contentOffset = strongSelf.outerScrollView.contentOffset
            contentOffset.y = currentOffset.y.flat
            strongSelf.outerScrollView.setContentOffset(contentOffset, animated: false)
            strongSelf.scrollViewDidScroll(strongSelf.outerScrollView)
            if didEnd {
                strongSelf.scrollViewDidEndDecelerating(strongSelf.outerScrollView)
            }
        })
        self.nestedDeceleration?.isPaused = false
    }

    private lazy var blockView: UIView = {
        let blockView = UIView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        blockView.backgroundColor = UIColor.white
        return blockView
    }()
}

extension CGFloat {
    var flat: CGFloat {
        let scale = UIScreen.main.scale
        return floor(self * scale) / scale
    }
}
