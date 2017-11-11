//
//  CoRightsGirdViewCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CoRightsGirdViewCell: UICollectionViewCell, GirdCellType {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0x4A4A4A)
        titleLabel.font = UIFontMake(12)
        return titleLabel
    }()
    
    private lazy var imageBgView: UIView = {
        let imageBgView = UIView()
        imageBgView.layer.cornerRadius = 25
        return imageBgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let superView = UIView()
        contentView.addSubview(superView)
        superView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        superView.addSubview(imageBgView)
        
        imageBgView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        superView.addSubview(imageView)
        superView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(imageBgView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageBgView.snp.bottom).offset(16)
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    func updateCell(with item: GirdRightsItem) {
        imageView.image = UIImage(named: item.imageName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = item.title
        perform(Selector(item.selectorName))
    }

    @objc
    private func coRightsStyle() {
        imageBgView.layer.borderColor = UIColor(hex: 0x763E82).cgColor
        imageBgView.layer.borderWidth = 1
        imageView.tintColor = UIColor(hex: 0x763E82)
    }

    @objc
    private func memberRightsStyle() {
        imageBgView.backgroundColor = UIColor(hex: 0xEBF5FF)
        imageView.tintColor = UIColor(hex: 0x4A90E2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
