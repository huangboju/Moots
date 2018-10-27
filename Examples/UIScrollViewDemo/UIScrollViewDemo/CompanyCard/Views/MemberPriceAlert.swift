//
//  MemberPrice.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct MemberPriceItem {
    let price: String
    let memberLevel: MemberLevel
    let discount: String
}

class MemberPriceCell: UITableViewCell, Updatable {
    
    private lazy var memberBage: MemberBadge = {
        let memberBage = MemberBadge()
        return memberBage
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor(hex: 0x333333)
        priceLabel.font = UIFontMake(10)
        return priceLabel
    }()

    private lazy var discountLabel: UILabel = {
        let discountLabel = UILabel()
        discountLabel.textColor = UIColor(hex: 0x4D4D4D)
        discountLabel.font = UIFontMake(12)
        return discountLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(memberBage)
        memberBage.snp.makeConstraints { (make) in
            make.leading.equalTo(34)
            make.width.equalTo(68)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(memberBage.snp.trailing).offset(14)
        }
        
        contentView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(viewData: MemberPriceItem) {
        memberBage.memberLevel = viewData.memberLevel
        priceLabel.text = viewData.price
        discountLabel.text = viewData.discount
    }
}

class MemberPriceAlert: UIView {
    private let formView: FormView = {
        let formView = FormView()
        formView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        formView.separatorStyle = .none
        formView.isScrollEnabled = false
        formView.allowsSelection = false
        formView.backgroundColor = .white
        formView.layer.cornerRadius = 8
        return formView
    }()
    
    static let size = UIScreen.main.bounds.size
    static let formViewWidth: CGFloat = 270
    
    override init(frame: CGRect) {
        
        let cls = type(of: self)
        
        super.init(frame: CGRect(x: 0, y: -cls.size.height, width: cls.size.width, height: 0))
        
        
        let formHeaderView = UILabel(frame: CGSize(width: cls.formViewWidth, height: 44).rect)
        formHeaderView.text = "华住会员价"
        formHeaderView.textAlignment = .center
        formHeaderView.font = UIFontMake(14)
        formHeaderView.textColor = UIColor(hex: 0x4A4A4A)
        formView.tableHeaderView = formHeaderView
        
        
        let formFooterView = UIView(frame: CGSize(width: cls.formViewWidth, height: 64).rect)
        let closeBtn = HZUIHelper.generateNormalButton(title: "知道了", target: self, action: #selector(closeAction))
        closeBtn.setTitleColor(.black, for: .normal)
        closeBtn.setTitleColor(.gray, for: .highlighted)
        closeBtn.frame = CGSize(width: 229, height: 34).rect
        closeBtn.layer.cornerRadius = 4
        closeBtn.layer.borderColor = UIColor(hex: 0xD9D9D9).cgColor
        closeBtn.layer.borderWidth = 1
        closeBtn.titleLabel?.font = UIFontMake(14)
        formFooterView.addSubview(closeBtn)
        closeBtn.center = formFooterView.center

        formView.tableFooterView = formFooterView
        
        let topMargin: CGFloat = 209

        addSubview(formView)
        formView.snp.makeConstraints { (make) in
            make.width.equalTo(270)
            make.height.equalTo(268)
            make.centerX.equalToSuperview()
            make.top.equalTo(topMargin)
        }
    }
    
    func show() {
        guard superview == nil else {
            return
        }
        
        let discounts = [
            "（9.5折）",
            "（9.2折）",
            "（8.8折）",
            "（8.8折）",
            "（8.5折）"
        ]

        let rows = discounts.map {
            Row<MemberPriceCell>(viewData: MemberPriceItem(price: "￥449", memberLevel: .star, discount: $0))
        }

        formView.rows = [rows]

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
    private func closeAction() {
        dissmiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

