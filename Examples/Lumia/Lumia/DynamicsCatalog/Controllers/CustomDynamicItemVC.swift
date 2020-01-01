//
//  CustomDynamicItemVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/1/1.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

extension UIButton: ResizableDynamicItem {}

class CustomDynamicItemVC: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 200, width: 120, height: 40)
        button.setBackgroundImage(UIImage(named: "Button_Mask"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    var animator: UIDynamicAnimator?
    
    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        sender.bounds = CGRect(x: 0, y: 0, width: 120, height: 40)
        
        // UIDynamicAnimator instances are relatively cheap to create.
        let animator = UIDynamicAnimator(referenceView: view)
        
        // APLPositionToBoundsMapping maps the center of an id<ResizableDynamicItem>
        // (UIDynamicItem with mutable bounds) to its bounds.  As dynamics modifies
        // the center.x, the changes are forwarded to the bounds.size.width.
        // Similarly, as dynamics modifies the center.y, the changes are forwarded
        // to bounds.size.height.
        let buttonBoundsDynamicItem = PositionToBoundsMapping(target: sender)

        // Create an attachment between the buttonBoundsDynamicItem and the initial
        // value of the button's bounds.
        let attachmentBehavior = UIAttachmentBehavior(item: buttonBoundsDynamicItem, attachedToAnchor:buttonBoundsDynamicItem.center)
        attachmentBehavior.frequency = 2
        attachmentBehavior.damping = 0.3
        animator.addBehavior(attachmentBehavior)
        
        
        let pushBehavior = UIPushBehavior(items: [buttonBoundsDynamicItem], mode: .instantaneous)
        pushBehavior.angle = .pi / 4
        pushBehavior.magnitude = 2.0
        animator.addBehavior(pushBehavior)
        
        pushBehavior.active = true

        self.animator = animator
    }
}
