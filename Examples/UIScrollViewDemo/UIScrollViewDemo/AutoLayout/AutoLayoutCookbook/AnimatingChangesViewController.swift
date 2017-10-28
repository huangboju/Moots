//
//  AnimatingChangesViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/28.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AnimatingChangesViewController: AutoLayoutBaseController {
    var timer: Timer?
    
    var bottomConstraint: NSLayoutConstraint!
    var spaceBetweenViewsConstraints: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!

    var blueBox: UIView!
    var redBox: UIView!
    
    var offscreenViews: [UIView] = []

    override func initSubviews() {
        
        let colors = [
            0x00FF00,
            0xFFFF00
        ]

        for color in colors {
            let subview = generateView(with: UIColor(hex: color))
            offscreenViews.append(subview)
        }

        blueBox = generateView(with: UIColor(hex: 0x3953FF))
        view.addSubview(blueBox)
        
        blueBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topConstraint = blueBox.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16)
        topConstraint.isActive = true
        blueBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        redBox = generateView(with: UIColor(hex: 0xCC3300))
        view.addSubview(redBox)

        redBox.leadingAnchor.constraint(equalTo: blueBox.leadingAnchor).isActive = true
        redBox.heightAnchor.constraint(equalTo: blueBox.heightAnchor).isActive = true
        spaceBetweenViewsConstraints = redBox.topAnchor.constraint(equalTo: blueBox.bottomAnchor, constant: 8)
        spaceBetweenViewsConstraints.isActive = true
        redBox.trailingAnchor.constraint(equalTo: blueBox.trailingAnchor).isActive = true
        bottomConstraint = redBox.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -16)
        bottomConstraint.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViews), userInfo: nil, repeats: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }


    // MARK: Convenience
    @objc func updateViews(_ timer: Timer) {
        let margins = view.layoutMarginsGuide
        
        let leaving = redBox
        let entering = cycleViews(leaving!)

        // Entering view should not have any constraints.
        assert(entering.constraintsAffectingLayout(for: .vertical).count == 0)
        assert(entering.constraintsAffectingLayout(for: .horizontal).count == 0)
        
        view.addSubview(entering)
        
        // Set the initial size and location.
        entering.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        entering.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        entering.heightAnchor.constraint(equalTo: blueBox.heightAnchor).isActive = true
        
        let newSpaceBetweenViews = blueBox.topAnchor.constraint(equalTo: entering.bottomAnchor, constant: 20.0)
        newSpaceBetweenViews.isActive = true

        // Layout the subviews.
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            // Update the positions.
            self.topConstraint.isActive = false
            self.bottomConstraint.isActive = false
            
            /*
             As the views move into the center of the screen, the space
             between them should shrink to 8.0 points.
             */
            newSpaceBetweenViews.constant = 8.0
            
            /*
             As the lower view moves off the screen, the space between views
             should expand back to 20.0 points, pushing it completely off
             the screen.
             */
            self.spaceBetweenViewsConstraints.constant = 20.0
            
            self.topConstraint = entering.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20.0)
            self.topConstraint.isActive = true
            
            self.bottomConstraint = self.bottomLayoutGuide.topAnchor.constraint(equalTo: self.blueBox.bottomAnchor, constant: 20.0)
            self.bottomConstraint.isActive = true
            
            self.view.layoutIfNeeded()
            
            }, completion: { _ in

                // All constraints are removed when the view is removed from the view hierarchy.
                self.redBox.removeFromSuperview()
                
                // Update instance variables.
                self.redBox = self.blueBox
                self.blueBox = entering
                self.spaceBetweenViewsConstraints = newSpaceBetweenViews

                // Schedule the next update.
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateViews), userInfo: nil, repeats: false)
        })
    }

    fileprivate func cycleViews(_ current: UIView) -> UIView {
        let nextView = offscreenViews.removeLast()
        offscreenViews.insert(current, at: 0)
        return nextView
    }

    private func generateView(with color: UIColor) -> UIView {
        let subview = UIView()
        subview.backgroundColor = color
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }
}
