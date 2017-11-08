//
//  VerifyCoInfoFieldCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct VerifyCoInfoFieldItem {
    let placeholder: String
    let title: String
}

class VerifyCoInfoFieldCell: UITableViewCell, Updatable {

    public var inputText: String? {
        return textField.text
    }

    private lazy var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private lazy var leftView: UILabel = {
        let label = UILabel(frame: CGSize(width: 100, height: 20).rect)
        label.textColor = UIColor(hex: 0x333333)
        label.font = UIFontMake(13)
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        textField.leftView = leftView
        textField.leftViewMode = .always

        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalTo(PADDING)
            make.trailing.equalTo(-PADDING)
        }

        HZUIHelper.generateBottomLine(in: contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewData: VerifyCoInfoFieldItem) {
        let attr = NSAttributedString(string: viewData.placeholder, attributes: [
            .font: UIFontMake(15),
            .foregroundColor: UIColor(hex: 0x9B9B9B)
            ])

        textField.attributedPlaceholder = attr

        leftView.text = viewData.title
    }
}
