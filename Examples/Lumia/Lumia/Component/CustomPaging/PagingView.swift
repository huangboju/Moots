//
//  PagingView.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 26/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit
import pop


final class PagingView: UIView {
    
    let contentView: UIScrollView
    
    var anchors: [CGPoint] = []
    
    var decelerationRate: CGFloat = UIScrollView.DecelerationRate.fast.rawValue
    
    /**
     @abstract The effective bounciness.
     @discussion Use in conjunction with 'springSpeed' to change animation effect. Values are converted into corresponding dynamics constants. Higher values increase spring movement range resulting in more oscillations and springiness. Defined as a value in the range [0, 20]. Defaults to 4.
     */
    var springBounciness: CGFloat = 4

    /**
     @abstract The effective speed.
     @discussion Use in conjunction with 'springBounciness' to change animation effect. Values are converted into corresponding dynamics constants. Higher values increase the dampening power of the spring resulting in a faster initial velocity and more rapid bounce slowdown. Defined as a value in the range [0, 20]. Defaults to 12.
     */
    var springSpeed: CGFloat = 12
    
    init(contentView: UIScrollView) {
        self.contentView = contentView
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // Stop system animation
        targetContentOffset.pointee = scrollView.contentOffset
    
        let offsetProjection = scrollView.contentOffset.project(initialVelocity: velocity,
            decelerationRate: decelerationRate)
        
        if let target = nearestAnchor(forContentOffset: offsetProjection) {
            snapAnimated(toContentOffset: target, velocity: velocity)
        }
    }
    
    func contentViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopSnappingAnimation()
    }
    
    // MARK: - Private
    
    private var minAnchor: CGPoint {
        let x = -contentView.adjustedContentInset.left
        let y = -contentView.adjustedContentInset.top
        return CGPoint(x: x, y: y)
    }
    
    private var maxAnchor: CGPoint {
        let x = contentView.contentSize.width - bounds.width + contentView.adjustedContentInset.right
        let y = contentView.contentSize.height - bounds.height + contentView.adjustedContentInset.bottom
        return CGPoint(x: x, y: y)
    }
    
    private func setupViews() {
        addSubview(contentView)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func nearestAnchor(forContentOffset offset: CGPoint) -> CGPoint? {
        guard let candidate = anchors.min(by: { offset.distance(to: $0) < offset.distance(to: $1) }) else {
            return nil
        }
        
        let x = candidate.x.clamped(to: minAnchor.x...maxAnchor.x)
        let y = candidate.y.clamped(to: minAnchor.y...maxAnchor.y)
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Private: Animation
    
    private static let snappingAnimationKey = "CustomPaging.PagingView.scrollView.snappingAnimation"
    
    private func snapAnimated(toContentOffset newOffset: CGPoint, velocity: CGPoint) {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
        animation.velocity = velocity
        animation.toValue = newOffset
        animation.fromValue = contentView.contentOffset
        animation.springBounciness = springBounciness
        animation.springSpeed = springSpeed

        contentView.pop_add(animation, forKey: PagingView.snappingAnimationKey)
    }
    
    private func stopSnappingAnimation() {
        contentView.pop_removeAnimation(forKey: PagingView.snappingAnimationKey)
    }
}
