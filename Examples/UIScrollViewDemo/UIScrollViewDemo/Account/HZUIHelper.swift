//
//  HZUIHelper.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

class HZUIHelper {

    /// tableView 上的按钮
    static func generateFooterButton(with title: String?, target: Any?, action: Selector) -> UIView {
        let button = generateDarkButton(with: title, target: target, action: action)
        let footerView = UIView(frame: CGSize(width: SCREEN_WIDTH, height: button.frame.maxY).rect)
        footerView.addSubview(button)
        return footerView
    }

    /// 实心按钮
    static func generateDarkButton(with title: String?, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: PADDING, y: 0, width: SCREEN_WIDTH - 2 * PADDING, height: 44))
//        button.adjustsButtonWhenHighlighted = true
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0xA356AB)
        button.titleLabel?.font = UIFontMake(14)
        button.layer.cornerRadius = 5
//        button.highlightedBackgroundColor = button.backgroundColor?.qmui_transition(to: UIColor(white: 0.3, alpha: 0.3), progress: 1) // 高亮时的背景色
        return button
    }

    static func generateBottomLine(in superView: UIView) {
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xEBEBEB)
        superView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(PADDING)
            make.trailing.equalTo(-PADDING)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    static func generateNormalButton(title: String? = nil, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        return button
    }

    static func generateNormalButton(imageName: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    static func renderTranslucentNav(in vc: UIViewController) {
        vc.automaticallyAdjustsScrollViewInsets = false
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.edgesForExtendedLayout = .all
    }
}
