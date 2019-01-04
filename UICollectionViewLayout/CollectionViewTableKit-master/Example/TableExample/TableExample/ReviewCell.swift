//
//  ReviewCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

private let avatarWidth: CGFloat = 50

class ReviewCell: DefaultCollectionViewCell, CollectionViewCell {

    typealias CellContent = (author: NSAttributedString, date: NSAttributedString, text: NSAttributedString, avatar: UIImage?)

    var content: CellContent? {
        didSet {
            authorLabel.attributedText = content?.author
            dateLabel.attributedText = content?.date
            textView.attributedText = content?.text
            avatarView.image = content?.avatar
        }
    }

    private let authorLabel = UILabel()

    private let dateLabel = UILabel()

    private let textView = UITextView()

    private let avatarView = UIImageView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layoutMargins = UIEdgeInsets(allSides: spacing)

        var views = [String: UIView]()

        authorLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        views["authorLabel"] = authorLabel
        contentView.addSubview(authorLabel)

        authorLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        views["dateLabel"] = dateLabel
        contentView.addSubview(dateLabel)

        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isOpaque = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        views["textView"] = textView
        contentView.addSubview(textView)

        avatarView.backgroundColor = .gray
        avatarView.layer.cornerRadius = 3
        avatarView.layer.masksToBounds = true
        avatarView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        avatarView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        views["avatarView"] = avatarView
        contentView.addSubview(avatarView)

        let metrics = ["spacing": spacing, "halfSpacing": spacing/2]

        let constraints = [
            "H:|-[avatarView]-(halfSpacing)-[authorLabel]-[dateLabel]-|",
            "H:[avatarView]-(halfSpacing)-[textView]-|",
            "V:|-[avatarView]",
            "V:|-[authorLabel]-(halfSpacing)-[textView]-|",
            "V:|-[dateLabel]",
        ].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: metrics, views: views)
        } + [
            avatarView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: avatarWidth),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    static func calculateHeight(content: CellContent, forWidth width: CGFloat) -> CGFloat {

        let availableSpace = width - avatarWidth - spacing*2 - spacing/2

        let authorSize = content.author.boundingRect(
            with: CGSize(width: availableSpace, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        let textSize = content.text.boundingRect(
            with: CGSize(width: availableSpace, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return textSize.height + authorSize.height + spacing*2 + spacing/2 + 2
    }
}
