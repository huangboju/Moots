//
//  IconTextView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

enum IconTextViewPosition: Int {
    case top = 0 // imageView在titleLabel上面
    case left    // imageView在titleLabel左边
    case bottom  // imageView在titleLabel下面
    case right   // imageView在titleLabel右边
}

class IconTextView: UIView {
    
    var imagePosition: IconTextViewPosition = .left {
        didSet {
            setNeedsLayout()
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            setNeedsLayout()
        }
    }
    
    var text: String? {
        didSet {
            textLabel.text = text
            setNeedsLayout()
        }
    }

    var adjustsFontSizeToFitWidth = false {
        didSet {
            textLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
    }

    var textColor: UIColor = UIColor.black {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    var textFont: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize) {
        didSet {
            textLabel.font = textFont
        }
    }
    
    var interval: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        switch imagePosition {
        case .top:
            textLabel.textAlignment = .center
            imageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            }
            
            textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(interval)
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
        case .bottom:
            textLabel.textAlignment = .center
            textLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(textLabel.snp.bottom).offset(interval)
                make.centerX.bottom.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            }
        case .left:
            imageView.snp.makeConstraints({ (make) in
                make.leading.centerY.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
            })
            
            textLabel.snp.makeConstraints({ (make) in
                make.leading.equalTo(imageView.snp.trailing).offset(interval)
                make.top.bottom.trailing.equalToSuperview()
            })
        case .right:
            
            textLabel.snp.makeConstraints({ (make) in
                make.leading.top.bottom.equalToSuperview()
                make.centerY.equalTo(imageView)
            })
            
            imageView.snp.makeConstraints({ (make) in
                make.leading.equalTo(textLabel.snp.trailing).offset(interval)
                make.bottom.lessThanOrEqualToSuperview()
                make.trailing.equalToSuperview()
            })
        }
    }
}
