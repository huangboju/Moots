//
//  ViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 04/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

final class TouchViewController: SafeAreaViewController {
    
    private lazy var touchView: TouchView = {
        let view = TouchView()
        return view
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(touchViewPanned))
        return recognizer
    }()

    private var touchViewPositionValue: CGPoint?
    private var touchViewPositionOffset = CGPoint.zero
    private var needsUpdateTouchViewPosition = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .grayBackgroundColor
        
        view.addSubview(touchView)
        view.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutTouchView()
    }

    private func layoutTouchView() {
        let positionValue = touchViewPositionValue != nil ? touchViewPositionValue! : CGPoint(x: 0.5, y: 0.5)
        touchView.frame.size.width = 300.0
        touchView.frame.size.height = 300.0
        touchView.center.x = positionValue.x * view.bounds.width
        touchView.center.y = positionValue.y * view.bounds.height
    }
        
    // MARK: - Actions
    
    @objc private func touchViewPanned() {
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:
            needsUpdateTouchViewPosition = touchView.frame.contains(location)
            touchViewPositionOffset.x = location.x - touchView.center.x
            touchViewPositionOffset.y = location.y - touchView.center.y
        case .ended, .cancelled, .failed:
            needsUpdateTouchViewPosition = false
            touchViewPositionOffset = CGPoint.zero
        default:
            if needsUpdateTouchViewPosition {
                touchViewPositionValue = CGPoint(
                    x: (location.x - touchViewPositionOffset.x) / view.bounds.width,
                    y: (location.y - touchViewPositionOffset.y) / view.bounds.height
                )
                layoutTouchView()
            }
        }
    }    
}
