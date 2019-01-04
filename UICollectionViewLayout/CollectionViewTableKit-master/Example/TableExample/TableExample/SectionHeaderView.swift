//
//  SectionHeaderView.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {

    static let viewReuseIdentifer = "SectionHeaderView"

    var title: String? {
        didSet {
            titleLabel.attributedText = title?.attributedString
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        var views = [String: UIView]()

        layoutMargins = UIEdgeInsets(top: spacing*2, left: spacing, bottom: spacing, right: spacing)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        views["title"] = titleLabel
        addSubview(titleLabel)

        let constraints = [
            "H:|-[title]-|",
            "V:|-[title]-|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: views)
        }

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        titleLabel.attributedText = nil
    }

    static func calculateHeight(title: String?, forWidth width: CGFloat) -> CGFloat {

        guard let title = title, !title.isEmpty else {
            return 0
        }

        let availableSpace = width - spacing*2

        let titleSize = title.attributedString.boundingRect(
            with: CGSize(width: availableSpace, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return titleSize.height + spacing*3 + 2
    }
}

private extension String {

    var attributedString: NSAttributedString {
        return NSAttributedString(string: self, attributes: Typography.sectionHeaderAttributes)
    }
}
