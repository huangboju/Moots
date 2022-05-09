//
//  UIKitDynamicsViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/28.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class UIKitDynamicsViewController: AutoLayoutBaseController {
    var animator: UIDynamicAnimator!
    
    var gravity: UIGravityBehavior!
    
    var collision: UICollisionBehavior!
    
    var dynamicView: UIView!
    

    override func initSubviews() {

        let dummyView = generatDummyView()
        view.addSubview(dummyView)
        dynamicView = dummyView
        dummyView.alpha = 0.0
        
        animator = UIDynamicAnimator(referenceView: view)
        
        dynamicView.alpha = 0.0
        
        gravity = UIGravityBehavior(items: [dummyView])
        
        collision = UICollisionBehavior(items: [dummyView])

        let boundaryInsets = UIEdgeInsets(top: -200.0, left: -20.0, bottom: 20.0, right: 20.0)
        collision.setTranslatesReferenceBoundsIntoBoundary(with: boundaryInsets)
        
        dummyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let textLabel = generateLabel(with: "My Controls")
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.textAlignment = .center
        dummyView.addSubview(textLabel)
        
        let activateLabel = generateLabel(with: "Activate")
        dummyView.addSubview(activateLabel)
        
        let skewLabel = generateLabel(with: "Skew")
        dummyView.addSubview(skewLabel)
        
        let switchControl1 = generateSwitch()
        dummyView.addSubview(switchControl1)
        
        
        let switchControl2 = generateSwitch()
        dummyView.addSubview(switchControl2)
        
        
        let switchControl3 = generateSwitch()
        dummyView.addSubview(switchControl3)
        
        let stabilizeLabel = generateLabel(with: "Stabilize")
        dummyView.addSubview(stabilizeLabel)
        
        do {
            textLabel.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor, constant: 8).isActive = true
            dummyView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8).isActive = true
        }
        
        do {
            activateLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl1.centerYAnchor.constraint(equalTo: activateLabel.centerYAnchor).isActive = true
            switchControl1.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
            switchControl1.leadingAnchor.constraint(equalTo: activateLabel.trailingAnchor, constant: 8).isActive = true
            switchControl1.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        do {
            stabilizeLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl2.topAnchor.constraint(equalTo: switchControl1.bottomAnchor, constant: 8).isActive = true
            switchControl2.leadingAnchor.constraint(equalTo: stabilizeLabel.trailingAnchor, constant: 8).isActive = true
            switchControl2.centerYAnchor.constraint(equalTo: stabilizeLabel.centerYAnchor).isActive = true
            switchControl2.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
        }
        
        do {
            skewLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl3.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
            switchControl3.leadingAnchor.constraint(equalTo: skewLabel.trailingAnchor, constant: 8).isActive = true
            switchControl3.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor).isActive = true
            switchControl3.centerYAnchor.constraint(equalTo: skewLabel.centerYAnchor).isActive = true
            switchControl3.topAnchor.constraint(equalTo: switchControl2.bottomAnchor, constant: 8).isActive = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setOffscreenPosition()
        dropView()
    }
    
    // MARK: Convenience
    
    fileprivate func setOffscreenPosition() {
        var center = view.center
        center.y = -(dynamicView.frame.height / 2.0)
        dynamicView.center = center
        
        animator.removeAllBehaviors()
    }

    fileprivate func dropView() {
        dynamicView.alpha = 1.0
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }

    private func generateLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func generateSwitch() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        switchControl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }
    
    private func generatDummyView() -> UIView {
        let dummyView = UIView()
        dummyView.backgroundColor = UIColor.orange
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }
}
