//
//  EmbedScrollViewVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/9/23.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation


class EmbedScrollViewVC: UIViewController, UIScrollViewDelegate {

    var outerDeceleration: ScrollingDeceleration?

    var nestedDeceleration: ScrollingDeceleration?

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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            outerScrollingDecelerator.invalidateIfNeeded()
        } else {
//            outerScrollView.isScrollEnabled = isOuterEnable
//            nestedScrollingDecelerator.invalidateIfNeeded()
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == outerScrollView {
            outerDeceleration = ScrollingDeceleration(velocity: velocity, decelerationRate: scrollView.decelerationRate)
        } else {
            nestedDeceleration = ScrollingDeceleration(velocity: velocity, decelerationRate: scrollView.decelerationRate)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == outerScrollView {
            outerDeceleration = nil
        } else {
            nestedDeceleration = nil
        }
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(#function)
//        if scrollView == outerScrollView {
//            outerDeceleration = nil
//        } else {
//            nestedDeceleration = nil
//        }
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == outerScrollView {
//            guard abs(scrollView.contentOffset.y - (300 - statusBarHeight - 44)) < .ulpOfOne else { return }
            nestedScrollingDecelerator.decelerate(by: outerDeceleration!)
        } else {
            if let nestedDeceleration = nestedDeceleration {
                outerScrollingDecelerator.decelerate(by: nestedDeceleration)
            }
        }
    }

    private lazy var nestedScrollingDecelerator: ScrollingDecelerator = {
        ScrollingDecelerator(scrollView: nestedScrollView)
    }()

    private lazy var outerScrollingDecelerator: ScrollingDecelerator = {
        ScrollingDecelerator(scrollView: outerScrollView)
    }()

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
        nestedScrollView.contentInsetAdjustmentBehavior = .never
        nestedScrollView.addSubview(blockView)
        return nestedScrollView
    }()

    private lazy var blockView: UIView = {
        let blockView = UIView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        blockView.backgroundColor = UIColor.white
        return blockView
    }()
}
