//
//  NestedScrollViewVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/4/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

final class ScrollingDecelerator {
    weak var scrollView: UIScrollView?
    var scrollingAnimation: TimerAnimationProtocol?
    let threshold: CGFloat
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        threshold = 0.1
    }
}

// MARK: - ScrollingDeceleratorProtocol
extension ScrollingDecelerator: ScrollingDeceleratorProtocol {
    func decelerate(by deceleration: ScrollingDeceleration) {
        guard let scrollView = scrollView else { return }
        let velocity = CGPoint(x: deceleration.velocity.x, y: deceleration.velocity.y * 1000 * threshold)
        scrollingAnimation = beginScrollAnimation(initialContentOffset: scrollView.contentOffset, initialVelocity: velocity, decelerationRate: deceleration.decelerationRate.rawValue) { [weak scrollView] point in
            guard let scrollView = scrollView else { return }
            if deceleration.velocity.y < 0 {
                scrollView.contentOffset.y = max(point.y, 0)
            } else {
                scrollView.contentOffset.y = max(0, min(point.y, scrollView.contentSize.height - scrollView.frame.height))
            }
        }
    }
    
    func invalidateIfNeeded() {
        guard scrollView?.isUserInteracted == true else { return }
        scrollingAnimation?.invalidate()
        scrollingAnimation = nil
    }
}

// MARK: - Privates
extension ScrollingDecelerator {
    private func beginScrollAnimation(initialContentOffset: CGPoint, initialVelocity: CGPoint,
                                      decelerationRate: CGFloat,
                                      animations: @escaping (CGPoint) -> Void) -> TimerAnimationProtocol {
        let timingParameters = ScrollTimingParameters(initialContentOffset: initialContentOffset,
                                                      initialVelocity: initialVelocity,
                                                      decelerationRate: decelerationRate,
                                                      threshold: threshold)
        return TimerAnimation(duration: timingParameters.duration, animations: { progress in
            let point = timingParameters.point(at: progress * timingParameters.duration)
            animations(point)
        })
    }
}

// MARK: - ScrollTimingParameters
extension ScrollingDecelerator {
    struct ScrollTimingParameters {
        let initialContentOffset: CGPoint
        let initialVelocity: CGPoint
        let decelerationRate: CGFloat
        let threshold: CGFloat
    }
}

extension ScrollingDecelerator.ScrollTimingParameters {
    var duration: TimeInterval {
        guard decelerationRate < 1
            && decelerationRate > 0
            && initialVelocity.length != 0 else { return 0 }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
    }
    
    func point(at time: TimeInterval) -> CGPoint {
        guard decelerationRate < 1
            && decelerationRate > 0
            && initialVelocity != .zero else { return .zero }
        
        let dCoeff = 1000 * log(decelerationRate)
        return initialContentOffset + (pow(decelerationRate, CGFloat(1000 * time)) - 1) / dCoeff * initialVelocity
    }
}

// MARK: - TimerAnimation
extension ScrollingDecelerator {
    final class TimerAnimation {
        typealias Animations = (_ progress: Double) -> Void
        typealias Completion = (_ isFinished: Bool) -> Void
        
        weak var displayLink: CADisplayLink?
        private(set) var isRunning: Bool
        private let duration: TimeInterval
        private let animations: Animations
        private let completion: Completion?
        private let firstFrameTimestamp: CFTimeInterval
        
        init(duration: TimeInterval, animations: @escaping Animations, completion: Completion? = nil) {
            self.duration = duration
            self.animations = animations
            self.completion = completion
            firstFrameTimestamp = CACurrentMediaTime()
            isRunning = true
            let displayLink = CADisplayLink(target: self, selector: #selector(step))
            displayLink.add(to: .main, forMode: .common)
            self.displayLink = displayLink
        }
    }
}

// MARK: - TimerAnimationProtocol
extension ScrollingDecelerator.TimerAnimation: TimerAnimationProtocol {
    func invalidate() {
        guard isRunning else { return }
        isRunning = false
        stopDisplayLink()
        completion?(false)
    }
}

// MARK: - Privates
extension ScrollingDecelerator.TimerAnimation {
    @objc private func step(displayLink: CADisplayLink) {
        guard isRunning else { return }
        let elapsed = CACurrentMediaTime() - firstFrameTimestamp
        if elapsed >= duration
            || duration == 0 {
            animations(1)
            isRunning = false
            stopDisplayLink()
            completion?(true)
        } else {
            animations(elapsed / duration)
        }
    }
    
    private func stopDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }
}

// MARK: - CGPoint
private extension CGPoint {
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}

final class ScrollingDeceleration {
    let velocity: CGPoint
    let decelerationRate: UIScrollView.DecelerationRate
    
    init(velocity: CGPoint, decelerationRate: UIScrollView.DecelerationRate) {
        self.velocity = velocity
        self.decelerationRate = decelerationRate
    }
}

// MARK: - Equatable
extension ScrollingDeceleration: Equatable {
    static func == (lhs: ScrollingDeceleration, rhs: ScrollingDeceleration) -> Bool {
        return lhs.velocity == rhs.velocity
            && lhs.decelerationRate == rhs.decelerationRate
    }
}

// MARK: - ScrollingDeceleratorProtocol
protocol ScrollingDeceleratorProtocol {
    func decelerate(by deceleration: ScrollingDeceleration)
    func invalidateIfNeeded()
}

// MARK: - TimerAnimationProtocol
protocol TimerAnimationProtocol {
    func invalidate()
}

// MARK: - UIScrollView
extension UIScrollView {
    // Indicates that the scrolling is caused by user.
    var isUserInteracted: Bool {
        return isTracking || isDragging || isDecelerating
    }
}

final class NestedScrollViewVC: UIViewController {
    private lazy var outerScrollView: OuterScrollView = {
        let outer = OuterScrollView()
        outer.backgroundColor = .systemGray
        return outer
    }()
    
    private lazy var nestedScrollView: NestedScrollView = {
        let nested = NestedScrollView()
        nested.backgroundColor = .systemBlue
        return nested
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(outerScrollView)
        outerScrollView.contentSize = CGSize(width: view.frame.width - 20, height: view.frame.height * 1.1)
        outerScrollView.frame = CGRect(x: 10, y: 50, width: view.frame.width - 20, height: view.frame.height - 88)
        
        outerScrollView.addSubview(nestedScrollView)
        outerScrollView.nested = nestedScrollView
        nestedScrollView.contentSize = CGSize(width: view.frame.width - 40, height: 5000)
        nestedScrollView.frame = CGRect(x: 10, y: 320, width: view.frame.width - 40, height: view.frame.height)
    }
}


final class OuterScrollView: UIScrollView, UIScrollViewDelegate {
    var outerDeceleration: ScrollingDeceleration?
    
    weak var nested: NestedScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        outerDeceleration = ScrollingDeceleration(velocity: velocity, decelerationRate: scrollView.decelerationRate)
        if let deceleration = outerDeceleration {
            nested?.decelerator.decelerate(by: deceleration)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        outerDeceleration = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        outerDeceleration = nil
    }
}

final class NestedScrollView: UIScrollView, UIScrollViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var decelerator: ScrollingDecelerator = {
        return ScrollingDecelerator(scrollView: self)
    }()

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        decelerator.invalidateIfNeeded()
    }
}
