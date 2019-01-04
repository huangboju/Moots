//
//  IconActionCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class IconActionCell: UICollectionViewCell, CollectionViewCell {

    typealias CellContent = Action

    var content: CellContent? {
        didSet {
            iconView.image = content?.icon
            titleLabel.attributedText = content?.attributedButtonTitle
        }
    }

    private let iconView = UIImageView()

    private let titleLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        var viewsDict = [String: UIView]()

        backgroundColor = .white

        contentView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        contentView.backgroundColor = .white

        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        contentView.addSubview(iconView)
        viewsDict["iconView"] = iconView

        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.thin)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        contentView.addSubview(titleLabel)
        viewsDict["titleLabel"] = titleLabel

        let constraints = [
            "H:|[iconView]|",
            "H:|-[titleLabel]-|",
            "V:|-[iconView]-7-[titleLabel]-|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: viewsDict)
        }

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .blue : .white
            iconView.tintColor = isHighlighted ? .white : .gray
            titleLabel.textColor = isHighlighted ? .white : .gray
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .blue : .white
            iconView.tintColor = isSelected ? .white : .gray
            titleLabel.textColor = isSelected ? .white : .gray
        }
    }

    static func calculateHeight(content: CellContent, forWidth width: CGFloat) -> CGFloat {

        return 80
    }
}
