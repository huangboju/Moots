//
//  AccountFooterView.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

class AccountFooterView: UIView {
    
    private(set) var button: UIButton!
    
    var groupViewTitle: (String, String)? {
        didSet {
            guard let groupViewTitle = groupViewTitle else {
                return
            }
            generatGroupView(with: groupViewTitle)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300))

        translatesAutoresizingMaskIntoConstraints = false

        button = HZUIHelper.generateNormalButton(with: self, action: #selector(buttonAction))
        button.backgroundColor = UIColor(hex: 0xA356AB)
//        button.highlightedBackgroundColor = button.backgroundColor?.qmui_transition(to: UIColor(white: 0.3, alpha: 0.3), progress: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFontMake(14)
        addSubview(button)

        button.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalToSuperview()
        }

        let tipLabel = NELineLabel()
        tipLabel.text = "或从以下方式登录"
        tipLabel.textAlignment = .center
        tipLabel.font = UIFontMake(13)
        tipLabel.textColor = UIColor(hex: 0x9B9B9B)
        tipLabel.lineColor = UIColor(hex: 0xF1F1F1)
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.width.equalTo(230)
            make.centerX.equalTo(snp.centerX)
        }
    }

    @objc func buttonAction() {}

    @objc func leftButtonAction() {}

    @objc func rightButtonAction() {}

    func generatGroupView(with titles: (String, String)) {
        let leftButton = generatButton(with: titles.0, action: #selector(leftButtonAction))
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom).offset(10)
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

    private func generatButton(with title: String, action: Selector) -> UIButton {
        let button = HZUIHelper.generateNormalButton(with: self, action: action)
        button.setTitleColor(UIColor(hex: 0x7E3886), for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFontMake(13)
        return button
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
