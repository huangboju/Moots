//
//  ViewController.swift
//  ScrollViewDelegate
//
//  Created by 伯驹 黄 on 2016/10/10.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = UIColor.groupTableViewBackground
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 5)
        scrollView.delegate = self
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let plateView = UIView()
        view.addSubview(plateView)
        
        view.addSubview(scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logDraggingAndDecelerating() {
        print(scrollView.isDragging ? "dragging" : "", scrollView.isDecelerating ? "decelerating" : "")
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let velocityValue = NSValue(cgPoint: velocity)
        let targetContentOffsetValue = NSValue(cgPoint: targetContentOffset.move())
        print("velocityValue=\(velocityValue), targetContentOffsetValue=\(targetContentOffsetValue)")
        logDraggingAndDecelerating()
        print("🍀🍀🍀\(#function)🍀🍀🍀")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        // 点击statusBar调用
        return true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("🍀🍀🍀\(#function)🍀🍀🍀")
        logDraggingAndDecelerating()
    }
}
