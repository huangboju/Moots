//
//  PendulumBehavior.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/1/1.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class PendulumBehavior: UIDynamicBehavior {

    private var draggingBehavior: UIAttachmentBehavior?
    private var pushBehavior: UIPushBehavior?

    public init(item: UIDynamicItem, suspendedFrom point: CGPoint) {
        super.init()
        // The high-level pendulum behavior is built from 2 primitive behaviors.

        let gravityBehavior = UIGravityBehavior(items: [item])
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: point)
        // These primative behaviors allow the user to drag the pendulum weight.
        let draggingBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: .zero)
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)

        pushBehavior.active = true

        addChildBehavior(gravityBehavior)
        addChildBehavior(attachmentBehavior)

        addChildBehavior(pushBehavior)
        // The draggingBehavior is added as needed, when the user begins dragging
        // the weight.

        self.draggingBehavior = draggingBehavior
        self.pushBehavior = pushBehavior
    }


    func beginDraggingWeight(at point: CGPoint) {
        draggingBehavior?.anchorPoint = point
        addChildBehavior(draggingBehavior!)
    }

    func dragWeight(to point: CGPoint) {
        draggingBehavior?.anchorPoint = point
    }

    func endDraggingWeight(with velocity: CGPoint) {
        var magnitude = sqrt(pow(velocity.x, 2.0) + pow(velocity.y, 2.0))
        let angle = atan2(velocity.y, velocity.x)

        // Reduce the volocity to something meaningful.  (Prevents the user from
        // flinging the pendulum weight).
        magnitude /= 500

        pushBehavior?.angle = angle
        pushBehavior?.magnitude = magnitude
        pushBehavior?.active = true

        removeChildBehavior(draggingBehavior!)
    }
}
