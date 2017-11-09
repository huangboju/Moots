//
//  MyCoRightsActiveCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsActiveCell: UITableViewCell, Updatable {

    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topFont = UIFontMake(18)
        doubleLabel.bottomFont = UIFontMake(14)
        doubleLabel.topTextColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.bottomTextColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.textAlignment = .left
        return doubleLabel
    }()

    private lazy var topLine: UIView = {
        let topLine = generateLine()
        return topLine
    }()
    
    private lazy var bottomLine: UIView = {
        let bottomLine = generateLine()
        return bottomLine
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(108).priority(.high)
            make.edges.equalToSuperview()
        }
        
        selectionStyle = .none

        let imageView = UIImageView(image: UIImage(named: "ic_my_coInfo_active"))
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }

        contentView.addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.trailing.equalTo(-PADDING)
        }

        doubleLabel.topText = "给华为同事送金卡"

        doubleLabel.bottomNumberOfLines = 2
        doubleLabel.bottomText = "aaaaaa"

        contentView.addSubview(topLine)
        contentView.addSubview(bottomLine)

        topLine.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(8)
        }

        bottomLine.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(topLine)
        }
    }

    private func generateLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return line
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            return try NSAttributedString(data: Data(utf8),
                                          options: options,
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

/*
 extension String {
 var html2AttributedString: NSAttributedString? {
 do {
 return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
 } catch {
 print("error:", error)
 return nil
 }
 }
 var html2String: String {
 return html2AttributedString?.string ?? ""
 }
 }
 */
