//
//  GoodsInfoCell.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation
import Kingfisher

protocol GoodsInfoCellDelegate: AnyObject {
    func infoCellChangeImageBtnClicked(_ cell: GoodsInfoCell)
}

class GoodsInfoCell: UITableViewCell, Reusable {

    var viewData: GoodsInfoCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(panelView)
        panelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(90)
        }

        panelView.addSubview(goodsImageView)
        goodsImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 74, height: 74))
        }

        panelView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(9)
            make.leading.equalTo(goodsImageView.snp.trailing).offset(12)
        }

        panelView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(goodsImageView)
            make.leading.equalTo(goodsImageView.snp.trailing).offset(12)
        }

        panelView.addSubview(changeImageBtn)
        changeImageBtn.snp.makeConstraints { maker in
            maker.left.right.equalTo(goodsImageView).inset(3)
            maker.bottom.equalTo(goodsImageView).inset(4)
            maker.height.equalTo(22)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}

    @objc
    func changeImageBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.infoCellChangeImageBtnClicked(self)
        viewData?.shouldShowMainImage = changeImageBtn.isSelected
    }

    var delegate: GoodsInfoCellDelegate? {
        viewController() as? GoodsInfoCellDelegate
    }

    private lazy var panelView: UIView = {
        let panelView = UIView()
        return panelView
    }()

    private lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.layer.cornerRadius = 4
        goodsImageView.clipsToBounds = true
        goodsImageView.backgroundColor = .gray
        return goodsImageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(hex: 0xD5D7DD)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        return priceLabel
    }()

    public private(set) lazy var changeImageBtn: UIButton = {
        let changeImageBtn = UIButton()
        changeImageBtn.setTitle("换主图", for: .normal)
        changeImageBtn.setTitle("换规格图", for: .selected)
        changeImageBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        changeImageBtn.backgroundColor = UIColor(hex: 0x333333).withAlphaComponent(0.5)
        changeImageBtn.setTitleColor(UIColor.white, for: .normal)
        changeImageBtn.layer.borderWidth = 1
        changeImageBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        changeImageBtn.addTarget(self, action: #selector(changeImageBtnClicked), for: .touchUpInside)
        changeImageBtn.layer.masksToBounds = true
        changeImageBtn.layer.cornerRadius = 12
        return changeImageBtn
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoodsInfoCell: Updatable {
    func update(viewData: GoodsInfoCellModel) {
        self.viewData = viewData
        titleLabel.text = viewData.name
        priceLabel.attributedText = viewData.priceAttributedText
        changeImageBtn.isSelected = viewData.shouldShowMainImage
        changeImageBtn.isHidden = viewData.isHiddenChangeButton
        goodsImageView.kf.setImage(with: URL(string: viewData.image))
    }
}
