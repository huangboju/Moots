//
//  CustomPresentationSecondViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/13.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class CustomPresentationSecondViewController: UIViewController {
    
    private lazy var slider: UISlider = {
        let height = self.view.frame.height
        let slider = UISlider(frame: CGRect(x: 0, y: height - 80, width: self.view.frame.width, height: 44))
        slider.addTarget(self, action: #selector(valueChanged), for: UIControl.Event.valueChanged)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0xFFAB63)
        
        view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(-20)
            }
        }
        updatePreferredContentSize(with: traitCollection)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(with: newCollection)
    }
    
    @objc
    func valueChanged(_ sender: UISlider) {
        preferredContentSize.height = CGFloat(sender.value)
    }
    
    //| ----------------------------------------------------------------------------
    //! Updates the receiver's preferredContentSize based on the verticalSizeClass
    //! of the provided \a traitCollection.
    //
    func updatePreferredContentSize(with traitCollection: UITraitCollection) {
        preferredContentSize = CGSize(width: view.bounds.width, height: traitCollection.verticalSizeClass == .compact ? 270 : 420)
        
        // To demonstrate how a presentation controller can dynamically respond
        // to changes to its presented view controller's preferredContentSize,
        // this view controller exposes a slider.  Dragging this slider updates
        // the preferredContentSize of this view controller in real time.
        //
        // Update the slider with appropriate min/max values and reset the
        // current value to reflect the changed preferredContentSize.
        slider.maximumValue = Float(preferredContentSize.height)
        slider.minimumValue = 220
        slider.value = slider.maximumValue
    }
}
