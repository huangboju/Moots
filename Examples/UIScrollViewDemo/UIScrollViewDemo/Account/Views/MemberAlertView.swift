//
//  MemberAlertView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MemberAlertView: UIView {
    private let contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: (SCREEN_WIDTH - 294) / 2, y: 136, width: 294, height: 400))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        return contentView
    }()

    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topTextColor = UIColor(hex: 0x4A90E2)
        doubleLabel.bottomTextColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.topFont = UIFontBoldMake(20)
        doubleLabel.bottomFont = UIFontMake(14)

        doubleLabel.topText = "恭喜您！升级为铂金会员"
        doubleLabel.bottomText = "您的个人会员等级已随企业会员等级提升"
        
        return doubleLabel
    }()
    
    private lazy var coRightsFrameView: CoRightsFrameView = {
        let coRightsFrameView = CoRightsFrameView()
        return coRightsFrameView
    }()

    private lazy var inviteButton: UIButton = {
        let inviteButton = HZUIHelper.generateNormalButton(title: "邀请更多同事成为铂金会员", target: self, action: #selector(inviteAction))
        inviteButton.titleLabel?.font = UIFontBoldMake(16)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.setTitleColor(.lightGray, for: .highlighted)
        inviteButton.backgroundColor = UIColor(hex: 0x3C97FF)
        inviteButton.layer.cornerRadius = 18
        return inviteButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = HZUIHelper.generateNormalButton(imageName: "ic_btn_close", target: self, action: #selector(closeAction))
        closeButton.frame = CGRect(x: self.frame.width - 78, y: 85, width: 25, height: 25)
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        return closeButton
    }()
    
    static let size = UIScreen.main.bounds.size

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -type(of: self).size.height, width: type(of: self).size.width, height: 0))
        
        let maxY = closeButton.frame.maxY
        let height = contentView.frame.minY - maxY
        let vLine = CALayer(frame: CGRect(x: closeButton.center.x - 0.5, y: closeButton.frame.maxY, width: 1, height: height))
        vLine.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(vLine)

        addSubview(closeButton)

        addSubview(contentView)
        
        contentView.addSubview(coRightsFrameView)
        
        contentView.addSubview(doubleLabel)
        
        contentView.addSubview(inviteButton)
        
        doubleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
        }

        coRightsFrameView.snp.makeConstraints { (make) in
            make.top.equalTo(doubleLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.height.equalTo(193)
            make.centerX.equalToSuperview()
        }

        inviteButton.snp.makeConstraints { (make) in
            make.leading.equalTo(41)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.height.equalTo(36)
        }
    }

    func show() {
        guard superview == nil else {
            return
        }

        UIApplication.shared.keyWindow?.addSubview(self)

        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = 0
            self.frame.size.height = type(of: self).size.height
        }, completion: { _ in
            self.backgroundColor = UIColor(white: 0, alpha: 0.6)
        })
    }

    func dissmiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundColor = .clear
            self.subviews.forEach { $0.removeFromSuperview() }
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    @objc
    private func inviteAction() {
        
    }

    @objc
    private func closeAction() {
        dissmiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MemberBadge: UILabel {
    var memberLevel: MemberLevel = .star {
        didSet {
            text =  memberLevel.rawValue + "权益"
            layer.backgroundColor = UIColor(hex: memberLevel.hex).cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 2

        layer.backgroundColor = UIColor(hex: memberLevel.hex).cgColor
        textColor = .white
        font = UIFontMake(12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MemberLevel: String {
    case star = "星会员"
    case silver = "银会员"
    case roseGold = "玫瑰金会员"
    case gold = "金会员"
    case platinum = "铂金会员"

    var hex: Int {
        switch self {
        case .star:
            return 0x4A90E2
        case .silver:
            return 0x99A5B0
        case .roseGold:
            return 0xD5A279
        case .gold:
            return 0xDD9828
        case .platinum:
            return 0x7E3886
        }
    }
}
