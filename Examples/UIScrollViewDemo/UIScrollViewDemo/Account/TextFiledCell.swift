//
//  TextFiledCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TextFiledCell: UITableViewCell, Updatable {
    
    typealias FileItem = (placeholder: String?, iconName: String)

    final var inputText: String? {
        return textField.text
    }
    
    final func setField(with item: FileItem) {
        var attri: NSAttributedString?
        if let placeholder = item.placeholder {
             attri = NSAttributedString(string: placeholder, attributes: [
                .font: UIFontMake(15)
                ])
        }
        textField.attributedPlaceholder = attri

        guard let icon = UIImage(named: item.iconName) else {
            textField.leftView = nil
            textField.leftViewMode = .never
            return
        }
        imageView?.image = icon
        textField.leftViewMode = .always
    }

    final func setRightView(with rightView: UIView?) {
        guard let rightView = rightView else {
            textField.rightView = nil
            textField.rightViewMode = .never
            return
        }
        textField.rightView = rightView
        textField.rightViewMode = .always
    }

    let textField = UITextField()

    private let bottomLine = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(45)
            make.trailing.equalTo(-16)
            make.top.bottom.equalTo(self)
        }
        textField.addTarget(self, action: #selector(editingDidBeginAction), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndAction), for: .editingDidEnd)

        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview()
        }
        bottomLine.backgroundColor = UIColor(hex: 0xCCCCCC)

        didInitialzed()
    }

    open func didInitialzed() {}

    @objc
    private func editingDidBeginAction() {
        bottomLine.backgroundColor = UIColor(hex: 0xA356AB)
    }

    @objc
    private func editingDidEndAction() {
        bottomLine.backgroundColor = UIColor(hex: 0xCCCCCC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewData: NoneItem) {}
}
