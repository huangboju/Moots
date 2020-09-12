//
//  ScrollViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 10/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        return scrollView
    }()

    private lazy var scrollLabel: UILabel = {
        let label = UILabel()
        if let filePath = Bundle.main.path(forResource: "Text", ofType: "txt") {
            label.text = try? String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
        }
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    var axisItem: ScrollViewScrollableAxisItem? {
        didSet {
            updateScrollViewContent()
        }
    }

    var behaviorItem: ScrollViewContentInsetAdjustmentBehaviorItem? {
        didSet {
            updateBehavior()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = true
        
        scrollView.addSubview(scrollLabel)
        view.addSubview(scrollView)
    }
    
    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame.origin.x = 0.0
        scrollView.frame.origin.y = 0.0
        scrollView.frame.size.width = view.bounds.width
        scrollView.frame.size.height = view.bounds.height
        
        updateScrollViewContent()
        
        print("//////////////////////////")
        print("scroll view frame = \(scrollView.frame)")
        print("scroll view content offset = \(scrollView.contentOffset)")
        print("scroll view content insets = \(scrollView.contentInset)")
        print("scroll view scroll indicator insets = \(scrollView.scrollIndicatorInsets)")
        if #available(iOS 11, *) {
            print("scroll view adjusted content insets = \(scrollView.adjustedContentInset)")
        }
        print("//////////////////////////")
    }
    
    private func updateScrollViewContent() {
        guard let axisItem = axisItem else {
            return
        }
        switch axisItem {
        case .vertical:
            scrollView.contentSize.width = 1.0 * scrollView.bounds.width
            scrollView.contentSize.height = 1.5 * scrollView.bounds.height
        case .horizontal:
            scrollView.contentSize.width = 1.5 * scrollView.bounds.width
            scrollView.contentSize.height = 1.0 * scrollView.bounds.height
        case .all:
            scrollView.contentSize.width = 1.5 * scrollView.bounds.width
            scrollView.contentSize.height = 1.5 * scrollView.bounds.height
        }
        scrollLabel.frame.origin.x = 0.0
        scrollLabel.frame.origin.y = 0.0
        scrollLabel.frame.size = scrollView.contentSize
    }

    private func updateBehavior() {
        guard #available(iOS 11, *) else {
            return
        }
        guard let behaviorItem = behaviorItem else {
            return
        }
        switch behaviorItem {
        case .automatic:
            scrollView.contentInsetAdjustmentBehavior = .automatic
        case .scrollableAxes:
            scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        case .never:
            scrollView.contentInsetAdjustmentBehavior = .never
        case .always:
            scrollView.contentInsetAdjustmentBehavior = .always
        }
    }
}
