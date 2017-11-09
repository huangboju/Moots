//
//  DoubleLabel.swift
//  wanlezu
//
//  Created by 伯驹 黄 on 2017/6/18.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

extension UIFont {
    static var systemFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
}

class DoubleLabel: UIView {

    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    /// Default 1
    var topNumberOfLines = 1 {
        didSet {
            topLabel.numberOfLines = topNumberOfLines
        }
    }
    
    /// Default 1
    var bottomNumberOfLines = 1 {
        didSet {
            bottomLabel.numberOfLines = bottomNumberOfLines
        }
    }

    /// Default 14 systemFont
    var topFont = UIFont.systemFont {
        didSet {
            topLabel.font = topFont
        }
    }

    /// Default 14 systemFont
    var bottomFont = UIFont.systemFont {
        didSet {
            bottomLabel.font = bottomFont
        }
    }

    /// Default UIColor.darkText
    var topTextColor = UIColor.darkText {
        didSet {
            topLabel.textColor = topTextColor
        }
    }

    /// Default UIColor.darkText
    var bottomTextColor = UIColor.darkText {
        didSet {
            bottomLabel.textColor = topTextColor
        }
    }

    /// Default 10
    var lineSpacing: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    var textAlignment: NSTextAlignment = .center {
        didSet {
            topLabel.textAlignment = textAlignment
            bottomLabel.textAlignment = textAlignment
        }
    }

    var topAttributText: NSAttributedString? {
        didSet {
            topLabel.attributedText = topAttributText
        }
    }

    var bottomAttributText: NSAttributedString? {
        didSet {
            bottomLabel.attributedText = bottomAttributText
        }
    }
    
    var topText: String? {
        didSet {
            topLabel.text = topText
        }
    }

    var bottomText: String? {
        didSet {
            bottomLabel.text = bottomText
        }
    }

    convenience init(alignment: NSTextAlignment = .center) {
        self.init(frame: .zero, alignment: alignment)
    }

    init(frame: CGRect, alignment: NSTextAlignment = .center) {
        super.init(frame: frame)
        textAlignment = alignment

        bottomLabel.font = bottomFont
        topLabel.font = topFont

        topLabel.textAlignment = alignment
        bottomLabel.textAlignment = alignment

        addSubview(topLabel)
        

        addSubview(bottomLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        bottomLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom).offset(lineSpacing)
            make.bottom.equalToSuperview()
        }
    }

    func setContent(_ content: (String, String)) {
        topText = content.0
        bottomText = content.1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
