//
//  NestedScrollViewVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/4/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation
import UIKit

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

extension UIView {

    var safeAreaBottom: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
         }
         return 0
    }

    var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
         }
         return 0
    }
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

final class NestedScrollViewVC: UIViewController, UIScrollViewDelegate {
    
    private lazy var topScrollView: UIScrollView = {
        let topScrollView = UIScrollView()
        topScrollView.contentInsetAdjustmentBehavior = .never
        topScrollView.delegate = self
        return topScrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.clipsToBounds = false
        return containerView
    }()
    
    private var stickyHeight: CGFloat {
        return 100
    }

    // https://stackoverflow.com/questions/13221488/uiscrollview-within-a-uiscrollview-how-to-keep-a-smooth-transition-when-scrolli
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.backgroundColor = .systemGreen
        
        view.addGestureRecognizer(tableView.panGestureRecognizer)
        tableView.removeGestureRecognizer(tableView.panGestureRecognizer)
        
        view.addSubview(containerView)

        let top: CGFloat = 191
        let bottom = view.safeAreaBottom
        containerView.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: top, width: view.frame.width, height: view.frame.height - top - bottom)

        view.addSubview(topScrollView)
        topScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        topScrollView.contentSize = CGSize(width: view.frame.width, height: 4400 + top * 2 - stickyHeight + bottom)
        let scrollviewOrigin = topScrollView.frame.origin;
        topScrollView.scrollIndicatorInsets = UIEdgeInsets(top: -scrollviewOrigin.y, left: 0, bottom: scrollviewOrigin.y, right: scrollviewOrigin.x)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //the scroll view underneath (in the container view) will have a max content offset equal to the content height
        //but minus the bounds height
        if scrollView.contentOffset.y <= stickyHeight {
            //in this scenario we are still within the content for the contained scrollview
            //so we make sure the container view is scrolled to the top and set the offset for the contained scrollview
            tableView.contentOffset = .zero

            containerView.bounds.origin.y = scrollView.contentOffset.y
        } else {
            tableView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y - stickyHeight)
            containerView.bounds.origin.y = stickyHeight
        }
    }
}

extension NestedScrollViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
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
