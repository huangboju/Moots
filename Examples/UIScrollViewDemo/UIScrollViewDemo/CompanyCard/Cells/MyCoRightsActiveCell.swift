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
        doubleLabel.topColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.bottomColor = UIColor(hex: 0x4A4A4A)
        return doubleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        let imageView = UIImageView(image: UIImage(named: "ic_my_coInfo_active"))
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-PADDING)
            make.top.equalTo(15)
        }

        doubleLabel.topText = "给华为同事送金卡"

//        doubleLabel.bottomAttributText = aaa.html2AttributedString

        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(92)
            make.leading.trailing.equalToSuperview()
        }
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
