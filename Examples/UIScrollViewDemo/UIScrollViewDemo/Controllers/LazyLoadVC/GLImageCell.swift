//
//  GLImageCell.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class GLImageCell: UITableViewCell {

    lazy var photoView: UIImageView = {
        let photoView = UIImageView(frame: self.bounds)
        photoView.contentMode = .scaleAspectFit
        return photoView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
