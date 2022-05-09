//
//  SignUpSuccessHeaderView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class SignUpSuccessHeaderView: UIView {
    
    private lazy var iconTextView: IconTextView = {
        let iconTextView = IconTextView()
        iconTextView.textColor = UIColor.white
        iconTextView.textFont = UIFontMake(15)
        iconTextView.image = UIImage(named: "ic_signup_success")
        iconTextView.text = "恭喜你成为华住星会员"
        return iconTextView
    }()

    private lazy var discountView: IconTextView = {
        let roomRateView = genreatIconTextView()
        roomRateView.image = UIImage(named: "ic_discount")
        roomRateView.text = "房费9.5折优惠"
        return roomRateView
    }()

    private lazy var integralView: IconTextView = {
        let integralView = genreatIconTextView()
        integralView.image = UIImage(named: "ic_integral")
        integralView.text = "房费9.5折优惠"
        return integralView
    }()

    private lazy var checkoutTimeView: IconTextView = {
        let checkoutTimeView = genreatIconTextView()
        checkoutTimeView.image = UIImage(named: "ic_checkout_time")
        checkoutTimeView.text = "13:00退房"
        return checkoutTimeView
    }()

    override init(frame: CGRect) {
        super.init(frame: CGSize(width: SCREEN_WIDTH, height: 260).rect)

        var rect = CGRect(x: 10, y: 9, width: SCREEN_WIDTH - 20, height: 220)

        do {
            let plateLayer = CALayer()
            plateLayer.frame = rect
            plateLayer.backgroundColor = UIColor.white.cgColor
            plateLayer.cornerRadius = 6
            layer.addSublayer(plateLayer)
        }

        do {
            let greenLayer = CAShapeLayer()
            greenLayer.fillColor = UIColor(hex: 0x42B987).cgColor

            rect.size.height = 62
            let bezier = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 6, height: 6))
            greenLayer.path = bezier.cgPath
            layer.addSublayer(greenLayer)
        }

        addSubview(iconTextView)
        iconTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.centerY.equalTo(40)
        }

        addSubview(discountView)
        discountView.snp.makeConstraints { (make) in
            make.leading.equalTo(iconTextView)
            make.top.equalTo(iconTextView.snp.bottom).offset(33)
        }

        addSubview(integralView)
        integralView.snp.makeConstraints { (make) in
            make.leading.equalTo(iconTextView)
            make.top.equalTo(discountView.snp.bottom).offset(20)
        }

        addSubview(checkoutTimeView)
        checkoutTimeView.snp.makeConstraints { (make) in
            make.leading.equalTo(iconTextView)
            make.top.equalTo(integralView.snp.bottom).offset(20)
        }
    }
    
    private func genreatIconTextView() -> IconTextView {
        let roomRateView = IconTextView()
        roomRateView.textFont = UIFontMake(13)
        roomRateView.textColor = UIColor(hex: 0x333333)
        roomRateView.interval = 6
        return roomRateView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
