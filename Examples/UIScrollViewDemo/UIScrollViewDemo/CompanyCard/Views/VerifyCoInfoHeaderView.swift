//
//  VerifyCoInfoHeaderView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

enum CompanyState: Int {
    case notCompanyCard = 0          // 不是公司卡
    case canBebound = 1              // 可以绑定
    case alreadyBound = 2            // 已绑定
    case expired = 3                 // 过期
    case unbundledSuccessfully = 4   // 解绑成功
    case toBeEmailed = 11            // 待发邮件
    case sentMail = 12               // 已发邮件
    case activated = 13              // 已激活
}

class VerifyCoInfoHeaderView: UIView {
    
    public var model: String? {
        didSet {
            doubleLabel.bottomText = model
            generatGroupRightsViews()
        }
    }

    private lazy var plateLayer: CAShapeLayer = {
        let plateLayer = CAShapeLayer()
        let rect = CGRect(x: PADDING, y: 15, width: SCREEN_WIDTH - 32, height: 125)
        plateLayer.frame = rect
        plateLayer.fillColor = UIColor(hex: 0x595175).cgColor
        
        let bezier = UIBezierPath(roundedRect: rect.size.rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        plateLayer.path = bezier.cgPath
        
        return plateLayer
    }()
    
    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topColor = .white
        doubleLabel.bottomColor = .white
        doubleLabel.textAlignment = .center
        return doubleLabel
    }()

    private lazy var pointImage: UIImage = {
        let color = UIColor(white: 1, alpha: 0.8)
        let image = color.image(size: CGSize(width: 4, height: 4), cornerRadius: 2)
        return image
    }()
    
    convenience init(state: CompanyState) {
        self.init(frame: CGSize(width: SCREEN_WIDTH, height: 140).rect)
        
        layer.addSublayer(plateLayer)
        
        addSubview(doubleLabel)
        
        generatSubViews(with: state)
    }
    
    private func generatSubViews(with state: CompanyState) {
        switch state {
        case .notCompanyCard:
            
            doubleLabel.topFont = UIFontMake(18)
            doubleLabel.bottomFont = UIFontMake(14)
            doubleLabel.topText = "您的公司可能是华住企业会员"
            doubleLabel.bottomText = "验证企业邮箱可享受同等权益"
            
            doubleLabel.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
        case .canBebound, .toBeEmailed, .sentMail, .activated:
            
            doubleLabel.topFont = UIFontMake(14)
            doubleLabel.bottomFont = UIFontMake(18)
            doubleLabel.topText = "验证企业邮箱升级会员等级"
            
            doubleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(40) // 33 = 15 + 18
                make.centerX.equalToSuperview()
            })
            
        default:
            break
        }
    }
    
    private func generatGroupRightsViews() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(34)
            make.trailing.equalTo(-34).priority(.high)
            make.bottom.equalToSuperview().offset(-29)
            make.top.equalTo(doubleLabel.snp.bottom).offset(10)
        }
        
        let names = [
            "房费8.8折",
            "免费早餐",
            "2倍积分",
            "延时退房至14:00"
        ]
        
        var tmpDummyView: UIView?
        var rightsTextView: IconTextView?
        
        for (i, name) in names.enumerated() {
            let iconTextView = IconTextView()
            iconTextView.text = name
            iconTextView.image = pointImage
            iconTextView.textColor = UIColor(white: 1, alpha: 0.8)
            iconTextView.interval = 3
            iconTextView.textFont = UIFontMake(13)
            containerView.addSubview(iconTextView)
            
            let dummyView = UIView()
            containerView.addSubview(dummyView)
            
            if let tmpDummyView = tmpDummyView, let rightsTextView = rightsTextView {
                iconTextView.snp.makeConstraints({ (make) in
                    make.top.equalTo(rightsTextView)
                    make.leading.equalTo(tmpDummyView.snp.trailing)
                    if i == names.count - 1 {
                        // 最后一个
                        make.trailing.equalToSuperview()
                    }
                })
                dummyView.snp.makeConstraints({ (make) in
                    make.width.equalTo(tmpDummyView)
                    make.leading.equalTo(iconTextView.snp.trailing)
                })
            } else {
                // 第一次
                iconTextView.snp.makeConstraints({ (make) in
                    make.top.bottom.leading.equalToSuperview()
                })
                dummyView.snp.makeConstraints({ (make) in
                    make.leading.equalTo(iconTextView.snp.trailing)
                })
            }
            
            tmpDummyView = dummyView
            rightsTextView = iconTextView
        }
    }
}
