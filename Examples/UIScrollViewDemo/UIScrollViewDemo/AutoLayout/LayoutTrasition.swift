//
//  LayoutTrasition.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class LayoutTrasition: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let button = UIButton()
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.width.equalTo(80)
            make.top.equalTo(200)
        }

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        view.addSubview(animatedView)
        animatedView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }

        // Start the animation
    }

    func startAnimation() {
        // Set the anchor point to the bottom center
        animatedView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0) // 设置锚点为底部居中

        // Create the animation
        UIView.animate(withDuration: 0.267, animations: {
            self.animatedView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.animatedView.alpha = 1
        }) { _ in
            // 动画完成后回到比例 1
            UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseIn, animations: {
                self.animatedView.transform = CGAffineTransform.identity
                self.animatedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }, completion: nil)
        }
    }

    @objc func buttonAction(sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        sender.snp.updateConstraints { (make) in
//            make.height.width.equalTo(sender.isSelected ? 200 : 80)
//        }
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn#imageLiteral(resourceName: "simulator_screenshot_973A5AA2-DF3B-4C61-A7CC-7A9EC3610CD2.png"), animations: {
//            sender.layoutIfNeeded()
//        }, completion: nil)

        startAnimation()
    }

    private lazy var animatedView: UIView = {
        let animatedView = UILabel()
        animatedView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        animatedView.alpha = 0.7
        animatedView.text = "你好"
        animatedView.textAlignment = .center
        animatedView.backgroundColor = .systemBlue
        return animatedView
    }()
}
