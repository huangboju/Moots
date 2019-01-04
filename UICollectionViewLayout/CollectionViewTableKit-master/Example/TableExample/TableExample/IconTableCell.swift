//
//  IconTableCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

private let iconWidth: CGFloat = spacing*2

class IconTableCell: DefaultCollectionViewCell, CollectionViewCell {

    typealias CellContent = Action

    var content: CellContent? {
        didSet {
            textLabel.attributedText = content?.attributedText

            if let icon = content?.icon {
                iconView.image = icon
                NSLayoutConstraint.deactivate(iconHiddenConstraints)
                NSLayoutConstraint.activate(iconConstraints)
            } else {
                iconView.image = nil
                NSLayoutConstraint.deactivate(iconConstraints)
                NSLayoutConstraint.activate(iconHiddenConstraints)
            }

            setNeedsDisplay()
        }
    }

    private let textLabel = UILabel()

    private let iconView = UIImageView()

    private var iconConstraints: [NSLayoutConstraint]!

    private var iconHiddenConstraints: [NSLayoutConstraint]!

    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layoutMargins = UIEdgeInsets(allSides: spacing)

        iconView.tintColor = .blue
        iconView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)

        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)

        let viewsDict: [String: UIView] = [
            "iconView": iconView,
            "textLabel": textLabel,
        ]

        let metrics = ["spacing": spacing, "halfSpacing": spacing/2]

        let iconConstraints = [
            "H:|-[iconView]-(halfSpacing)-[textLabel]-|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: metrics, views: viewsDict)
            } + [
                iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                textLabel.heightAnchor.constraint(greaterThanOrEqualTo: iconView.heightAnchor),
        ]
        self.iconConstraints = iconConstraints

        iconHiddenConstraints = [
            "H:|-[textLabel]-|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: metrics, views: viewsDict)
        }

        let defaultConstraints = [
            "V:|-[textLabel]-|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: metrics, views: viewsDict)
        }

        NSLayoutConstraint.activate(defaultConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    static func calculateHeight(content: CellContent, forWidth width: CGFloat) -> CGFloat {

        let availableSpace = width - spacing*2 - (content.icon == nil ? 0 : iconWidth + spacing/2)

        let textSize = content.attributedText.boundingRect(
            with: CGSize(width: availableSpace, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return max(textSize.height + spacing*2, iconWidth) + 2
    }
}
