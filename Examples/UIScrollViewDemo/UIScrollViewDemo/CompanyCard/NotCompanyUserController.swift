//
//  NotCompanyUserController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class NotCompanyUserHeaderView: UIView {
    public var model: String? {
        didSet {
            doubleLabel.bottomText = model
        }
    }

    private lazy var plateLayer: CAShapeLayer = {
        let plateLayer = CAShapeLayer()
        plateLayer.fillColor = UIColor(hex: 0x595175).cgColor
        return plateLayer
    }()
    
    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topTextColor = .white
        doubleLabel.bottomTextColor = .white
        doubleLabel.textAlignment = .center
        return doubleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: CGSize(width: SCREEN_WIDTH, height: 140).rect)

        layer.addSublayer(plateLayer)

        addSubview(doubleLabel)

        doubleLabel.topFont = UIFontMake(18)
        doubleLabel.bottomFont = UIFontMake(14)
        doubleLabel.topText = "您的公司可能是华住企业会员"
        doubleLabel.bottomText = "验证企业邮箱可享受同等权益"

        doubleLabel.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(x: PADDING, y: 15, width: frame.width - 32, height: 125)
        plateLayer.frame = rect
        let bezier = UIBezierPath(roundedRect: rect.size.rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        plateLayer.path = bezier.cgPath
    }
}

@objc
protocol CoVerifyActionable {
    func verifyAction()
}

class NotCompanyUserController: GroupTableController, CoVerifyActionable {
    override func initSubviews() {
        tableView.tableHeaderView = NotCompanyUserHeaderView()
        tableView.separatorStyle = .none

        rows = [
            [
                Row<CompanyInfoCell>(viewData: NoneItem()),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入您的企业邮箱", title: "工作邮箱")),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入公司名称", title: "公司名称")),
                Row<CoInfoVerifyCell>(viewData: NoneItem())
            ]
        ]
    }

    @objc
    func verifyAction() {
        
    }
}
