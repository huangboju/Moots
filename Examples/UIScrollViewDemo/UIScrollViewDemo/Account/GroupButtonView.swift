//
//  GroupButtonView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class GroupButtonView: UIView {
    func generatGroupView(with titles: (String, String)) {
        let leftButton = generatButton(with: titles.0, action: #selector(leftButtonAction))
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalTo(snp.centerX).offset(-15)
            make.width.equalTo(130)
        }

        let vLine = UIView()
        vLine.backgroundColor = .lightGray
        addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.equalTo(1)
            make.centerY.equalTo(leftButton.snp.centerY)
        }

        let rightButton = generatButton(with: titles.1, action: #selector(rightButtonAction))
        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftButton.snp.centerY)
            make.leading.equalTo(snp.centerX).offset(15)
            make.width.equalTo(leftButton)
        }
    }

    @objc func leftButtonAction() {}

    @objc func rightButtonAction() {}

    private func generatButton(with title: String, action: Selector) -> UIButton {
        let button = HZUIHelper.generateNormalButton(with: title, target: self, action: action)
        button.setTitleColor(UIColor(hex: 0x7E3886), for: .normal)
        button.titleLabel?.font = UIFontMake(13)
        return button
    }
}
