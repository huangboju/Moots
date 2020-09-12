//
//  ScrollContainerViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 12/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class ScrollContainerViewController: SafeAreaViewController {
        
    private lazy var behaviorItems: [ScrollViewContentInsetAdjustmentBehaviorItem] = {
        return [
            .automatic,
            .scrollableAxes,
            .always,
            .never,
        ]
    }()
    
    private lazy var axisItems: [ScrollViewScrollableAxisItem] = {
        return [
            .vertical,
            .horizontal,
            .all,
            ]
    }()
    
    lazy var behaviorLabel: UILabel = {
        let label = UILabel()
        label.text = "Content Insets Adjustment Behavior"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    lazy var axisLabel: UILabel = {
        let label = UILabel()
        label.text = "Scrollable Axes"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    private(set) lazy var behaviorSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: behaviorItems.map { item -> String in
            return item.rawValue
        })
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0)],
                                       for: .normal)
        control.addTarget(self, action: #selector(behaviorSegmentsAction), for: .valueChanged)
        return control
    }()
    
    private(set) lazy var axisSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: axisItems.map { item -> String in
            return item.rawValue
        })
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0)],
                                       for: .normal)
        control.addTarget(self, action: #selector(axisSegmentsAction), for: .valueChanged)
        return control
    }()
    
    private lazy var toolbarView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    private lazy var scrollViewController: ScrollViewController = {
        let viewController = ScrollViewController()
        return viewController
    }()
    
    private var scrollViewControllerAdditionalSafeAreaInsets = UIEdgeInsets.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .grayBackgroundColor
        
        addChild(scrollViewController)
        view.addSubview(scrollViewController.view)
        scrollViewController.didMove(toParent: self)
        
        toolbarView.contentView.addSubview(behaviorLabel)
        toolbarView.contentView.addSubview(behaviorSegmentedControl)
        toolbarView.contentView.addSubview(axisLabel)
        toolbarView.contentView.addSubview(axisSegmentedControl)
        view.addSubview(toolbarView)
        
        updateAxisItem()
        updateBehaviorItem()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollViewController.view.frame = view.bounds
        
        toolbarView.frame.origin.x = 0.0
        toolbarView.frame.size.width = view.bounds.width
        
        behaviorLabel.sizeToFit()
        behaviorLabel.frame.origin.y = 5.0
        behaviorLabel.center.x = toolbarView.bounds.width / 2.0
        
        behaviorSegmentedControl.sizeToFit()
        behaviorSegmentedControl.frame.origin.y = behaviorLabel.frame.maxY + 5.0
        behaviorSegmentedControl.center.x = toolbarView.bounds.width / 2.0
        
        axisLabel.sizeToFit()
        axisLabel.frame.origin.y = behaviorSegmentedControl.frame.maxY + 5.0
        axisLabel.center.x = toolbarView.bounds.width / 2.0
        
        axisSegmentedControl.sizeToFit()
        axisSegmentedControl.frame.origin.y = axisLabel.frame.maxY + 5.0
        axisSegmentedControl.center.x = toolbarView.bounds.width / 2.0
        
        toolbarView.frame.size.height = sa_safeAreaInsets.bottom + axisSegmentedControl.frame.maxY + 5.0
        toolbarView.frame.origin.y = view.bounds.height - toolbarView.frame.height
        
        updateScrollViewControllerAdditionalSafeAreaInsets()
    }
    
    private func updateScrollViewControllerAdditionalSafeAreaInsets() {
        if #available(iOS 11, *) {
            if toolbarView.isHidden {
                scrollViewController.additionalSafeAreaInsets = scrollViewControllerAdditionalSafeAreaInsets
            }
            else {
                scrollViewController.additionalSafeAreaInsets.top = scrollViewControllerAdditionalSafeAreaInsets.top
                scrollViewController.additionalSafeAreaInsets.left = scrollViewControllerAdditionalSafeAreaInsets.left
                scrollViewController.additionalSafeAreaInsets.bottom = toolbarView.frame.height - view.safeAreaInsets.bottom
                    + scrollViewControllerAdditionalSafeAreaInsets.bottom
                scrollViewController.additionalSafeAreaInsets.right = scrollViewControllerAdditionalSafeAreaInsets.right
            }
        }

    }
    
    // MARK: - Actions
    
    @objc private func behaviorSegmentsAction() {
        updateBehaviorItem()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func axisSegmentsAction() {
        updateAxisItem()
    }
    
    override func longPressed() {
        super.longPressed()
        toolbarView.isHidden = !toolbarView.isHidden
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // MARK: - Items

    private func updateAxisItem() {
        scrollViewController.axisItem = axisItems[axisSegmentedControl.selectedSegmentIndex]
    }
    
    private func updateBehaviorItem() {
        scrollViewController.behaviorItem = behaviorItems[behaviorSegmentedControl.selectedSegmentIndex]
    }

    // MARK: - Safe area 

    override func safeAreaInsetsLayerFrame() -> CGRect {
        return scrollViewController.sa_safeAreaFrame
    }
    
    override func updateAdditionalSafeAreaInsets(_ insets: UIEdgeInsets) {
        scrollViewControllerAdditionalSafeAreaInsets = insets
        updateScrollViewControllerAdditionalSafeAreaInsets()
    }
}
