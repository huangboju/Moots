//
//  GroupButtonView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class GroupButtonView: UIView {
    
    typealias GroupButtonViewItem = (title: String, action: Selector)
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!

    convenience init(target: Any, items: (GroupButtonViewItem, GroupButtonViewItem)) {
        self.init(frame: .zero)
        leftButton = generatButton(with: items.0.title, target: target, action: items.0.action)
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(snp.centerX).offset(-10)
            make.leading.equalToSuperview()
        }

        let vLine = UIView()
        vLine.backgroundColor = .lightGray
        addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.equalTo(1)
            make.center.equalToSuperview()
        }

        rightButton = generatButton(with: items.1.title, target: target, action: items.1.action)
        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftButton.snp.centerY)
            make.leading.equalTo(snp.centerX).offset(10)
            make.trailing.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rightButton.contentEdgeInsets.left = -(rightButton.frame.width - rightButton.intrinsicContentSize.width) / 2
        leftButton.contentEdgeInsets.right = -(leftButton.frame.width - leftButton.intrinsicContentSize.width) / 2
    }

    private func generatButton(with title: String?, target: Any, action: Selector) -> UIButton {
        let button = HZUIHelper.generateNormalButton(title: title, target: target, action: action)
        button.setTitleColor(UIColor(hex: 0x7E3886), for: .normal)
        button.titleLabel?.font = UIFontMake(13)
        return button
    }
}
