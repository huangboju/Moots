//
//  SKUItemCell.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class SKUHeader: UICollectionReusableView, Reusable {

    public var text: String? {
        get {
            headerLabel.text
        }
        set {
            headerLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.leading.equalTo(16)
            make.height.equalTo(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor(hex: 0xD5D7DD)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return headerLabel
    }()
}

class SKUItemCell: UICollectionViewCell, Reusable {
    public var model: SKUItemCellModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear

        initSubview()
    }

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 14

        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.125)
        return containerView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0xD5D7DD)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()

    private lazy var activityImageView: UIImageView = {
        let activityImageView = UIImageView()
        activityImageView.isHidden = true
        return activityImageView
    }()

    private lazy var tipLabelBG: UIImageView = {
        let tipLabelBG = UIImageView()
        tipLabelBG.isHidden = true
        return tipLabelBG
    }()

    private lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.font = self.tipFont
        tipLabel.textColor = UIColor.white
        tipLabel.layer.cornerRadius = 8
        tipLabel.isHidden = true
        return tipLabel
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            activityImageView
        ])
        stackView.alignment = .center
        activityImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        stackView.spacing = 3
        return stackView
    }()

    private var titleFont: UIFont {
        UIFont.systemFont(ofSize: 12)
    }

    private var selectedTitleFont: UIFont {
        UIFont.boldSystemFont(ofSize: 12)
    }

    private var tipFont: UIFont {
        UIFont.systemFont(ofSize: 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKUItemCell {
    private func initSubview() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(28)
        }

        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.center.equalTo(containerView)
        }

        containerView.addSubview(tipLabelBG)

        containerView.addSubview(tipLabel)


        tipLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tipLabel.snp.makeConstraints { make in
            make.right.equalTo(containerView).offset(-6)
            make.centerY.equalTo(containerView).offset(-15)
            make.height.equalTo(12)
        }

        tipLabelBG.snp.makeConstraints { make in
            make.right.equalTo(containerView)
            make.bottom.equalTo(containerView.snp.centerY)
            make.left.equalTo(tipLabel).offset(-6)
            make.height.equalTo(23)
        }
    }

    func update(viewData: SKUItemCellModel) {
        titleLabel.text = viewData.value

        activityImageView.isHidden = !viewData.isActivity

        if viewData.isSelected {
            tipLabel.textColor = UIColor.black
        } else {
            tipLabel.textColor = UIColor.white
        }

        switch viewData.status {
        case .normal:
            updateNormalCell(viewData)
        case .sellOut:
            updateSellOutCell(viewData)
        case .unfound:
            updateUnfoundCell()
        case .notSale:
            updateNotSaleCell(viewData)
        }
    }

    private func updateNormalCell(_ viewData: SKUItemCellModel) {
        tipLabelBG.isHidden = true
        tipLabel.isHidden = true
        if viewData.isSelected {
            containerView.backgroundColor = UIColor(hex: 0xFF2442).withAlphaComponent(0.2)
            titleLabel.textColor = UIColor(hex: 0xFF2442)
            titleLabel.font = selectedTitleFont
        } else {
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.125)
            titleLabel.textColor = UIColor(hex: 0x93979F)
            titleLabel.font = titleFont
        }
        updateActivityImage(isSelected: viewData.isSelected)
    }

    private func updateSellOutCell(_ viewData: SKUItemCellModel) {
        tipLabelBG.isHidden = false
        tipLabel.isHidden = false
        tipLabel.text = "售罄"
        if viewData.isSelected {
            containerView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            titleLabel.textColor = UIColor.systemRed
            titleLabel.font = selectedTitleFont
            tipLabelBG.image = UIImage(named: "xypk_goods_suk_tip_highlight")
        } else {
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.125)
            titleLabel.textColor = UIColor.white.withAlphaComponent(0.2)
            titleLabel.font = titleFont
            tipLabelBG.image = UIImage(named: "xypk_goods_suk_tip")
        }
        updateActivityImage(isSelected: viewData.isSelected)
    }

    private func updateUnfoundCell() {
        tipLabel.isHidden = true
        tipLabelBG.isHidden = true
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.125)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.2)
        titleLabel.font = titleFont
    }

    private func updateNotSaleCell(_ viewData: SKUItemCellModel) {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.125)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.2)
        titleLabel.font = titleFont
        tipLabel.isHidden = false
        tipLabel.text = "下架"
        tipLabelBG.isHidden = false
        tipLabelBG.image = UIImage(named: "xypk_goods_suk_tip")
        updateActivityImage(isNotSale: true)
    }

    private func updateActivityImage(isSelected: Bool = false, isNotSale: Bool = false) {
        if isNotSale {
            activityImageView.image = UIImage(named: "xypk_goods_suk_activity_unselect")
            return
        }

        if isSelected {
            activityImageView.image = UIImage(named: "xypk_goods_suk_activity_highlight")
        } else {
            activityImageView.image = UIImage(named: "xypk_goods_suk_activity_normal")
        }
    }

}
