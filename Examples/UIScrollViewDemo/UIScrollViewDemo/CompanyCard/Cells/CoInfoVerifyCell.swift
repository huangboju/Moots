//
//  CoInfoVerifyCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CoInfoVerifyCell: UITableViewCell, Updatable {
    
    private lazy var button: UIButton = {
        let button = HZUIHelper.generateDarkButton(with: "立即验证", target: viewController(), action: #selector(VerifyCoInfoController.verifyAction))
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let dummyLayer = CALayer()
        dummyLayer.backgroundColor = UIColor.white.cgColor
        dummyLayer.frame = CGSize(width: SCREEN_WIDTH, height: 29).rect
        contentView.layer.addSublayer(dummyLayer)
        
        backgroundColor = .groupTableViewBackground

        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(PADDING)
            make.trailing.equalTo(-PADDING)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(140)
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
