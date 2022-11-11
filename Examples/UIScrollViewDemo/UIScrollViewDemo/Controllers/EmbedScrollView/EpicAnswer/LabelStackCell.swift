//
//  StackCellBase.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/11/10.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import SnapKit
import StackScrollView

class StackCellBase: UIControl, StackCellType {

    init() {
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class LabelStackCell: StackCellBase {

    private lazy var cardView: CardView = {
        let cardView = CardView()
        return cardView
    }()

    init(title: String) {
        super.init()

        backgroundColor = UIColor(hex: 0xF5F5F5)

        addSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(-10)
            make.top.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}
