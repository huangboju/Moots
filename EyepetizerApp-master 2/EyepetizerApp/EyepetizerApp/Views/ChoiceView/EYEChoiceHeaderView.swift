//
//  EYEChoiceHeaderView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/16.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEChoiceHeaderView: UICollectionReusableView, Reusable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        addSubview(titleLabel)
        addSubview(imageView)
        titleLabel.snp_makeConstraints { [unowned self] (make) -> Void in
            make.edges.equalTo(self)
        }
        
        imageView.snp_makeConstraints { [unowned self] (make) -> Void in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).offset(self.height*0.25)
            make.height.equalTo(self.height*0.5)
        }
    }
    
    var title : String? {
        didSet {
            if let title = title {
                imageView.hidden = true
                titleLabel.hidden = false
                titleLabel.text = title
            } else {
                imageView.hidden = false
                titleLabel.hidden = true
            }
        }
    }

    var image : String? {
        didSet {
            if let image = image {
                titleLabel.hidden = true
                imageView.hidden = false
                imageView.yy_setImageWithURL(NSURL(string: image)!, options: .ProgressiveBlur)
            } else {
                titleLabel.hidden = false
                imageView.hidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel : UILabel = {
        var titleLabel : UILabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.customFont_Lobster(fontSize: UIConstant.UI_FONT_16)
        return titleLabel
    }()
    
    private lazy var imageView : UIImageView = {
        var imageView : UIImageView = UIImageView ()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
}
