//
//  ResetPasswordCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ResetPasswordFieldCell: UITableViewCell {
    
    public var inputText: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    public var icon: UIImage? {
        didSet {
            imageView?.image = icon
            textField.setNeedsDisplay()
        }
    }
    
    public var placeholder: String? {
        didSet {
            var attri: NSAttributedString?
            if let placeholder = placeholder {
                attri = NSAttributedString(string: placeholder, attributes: [
                    .font: UIFontMake(13),
                    .foregroundColor: UIColor(hex: 0xCCCCCC)
                    ])
            }
            textField.attributedPlaceholder = attri
        }
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
    
    public var isShowBottomLine = true {
        didSet {
            bottomLine.isHidden = isShowBottomLine
        }
    }
    
    
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex: 0xCCCCCC)
        return bottomLine
    }()
    
    let textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(59).priority(.high)
        }

        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(45)
            make.trailing.equalTo(-16)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(16)
            make.bottom.centerX.equalToSuperview()
        }
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initSubviews() {}
}

