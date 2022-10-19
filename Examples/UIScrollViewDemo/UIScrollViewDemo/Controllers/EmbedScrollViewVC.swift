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

        view.addSubview(nestedScrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == nestedScrollView {
            nestedScrollingDecelerator.invalidateIfNeeded()
        } else {
            outerScrollingDecelerator.invalidateIfNeeded()
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == outerScrollView {
            outerDeceleration = nil
        } else {
            nestedDeceleration = nil
        }
    }

    private lazy var nestedScrollingDecelerator: ScrollingDecelerator = {
        ScrollingDecelerator(scrollView: nestedScrollView)
    }()

    private lazy var outerScrollingDecelerator: ScrollingDecelerator = {
        ScrollingDecelerator(scrollView: nestedScrollView)
    }()

    private lazy var outerScrollView: UIScrollView = {
        let outerScrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 500))
        outerScrollView.contentSize = CGSize(width: view.frame.width, height: 700)
        outerScrollView.backgroundColor = .systemRed
        outerScrollView.delegate = self
        return outerScrollView
    }()

    private lazy var nestedScrollView: UIScrollView = {
        let nestedScrollView = UIScrollView(frame: CGRect(x: 0, y: 580, width: view.frame.width, height: 120))
        nestedScrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        nestedScrollView.backgroundColor = .systemGreen.withAlphaComponent(0.7)
        nestedScrollView.delegate = self
        return nestedScrollView
    }()
}
