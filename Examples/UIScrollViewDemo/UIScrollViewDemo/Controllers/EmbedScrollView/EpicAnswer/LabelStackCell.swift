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

final class LabelStackCell: StackCellBase {

    private let label = UILabel()

    init(title: String) {
        super.init()

        backgroundColor = .systemRed

        addSubview(label)

        label.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = title
    }
}
