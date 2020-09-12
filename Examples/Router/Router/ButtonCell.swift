//
//  ButtonCell.swift
//  Router
//
//  Created by 伯驹 黄 on 2016/12/7.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    var indexPath: IndexPath!
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkText.cgColor
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("测试", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryView = button
    }

    @objc func buttonAction(sender: UIButton) {
        sender.router(with: EventName.transferNameEvent, userInfo: [Keys.button: indexPath])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
