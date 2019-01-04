//
//  Fonts.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

private let smallPhone : CGFloat = 320
private let mediumPhone : CGFloat = 375
private let largePhone : CGFloat = 414
private let mediumiPad : CGFloat = 768
private let largeiPad : CGFloat = 1024

private let shortSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

private let fontSizeMedium: CGFloat = {
    switch shortSide {
    case smallPhone:
        return 15
    case mediumPhone, largePhone:
        return 16
    case mediumiPad, largeiPad:
        return 16
    default:
        return 15
    }
}()

struct Typography {

    typealias TypographyDictionary = [NSAttributedString.Key: Any]

    static let sectionHeader = UIFont.systemFont(ofSize: fontSizeMedium - 2, weight: UIFont.Weight.medium)
    static let sectionHeaderAttributes = createParagraphAttributes(
        font: sectionHeader,
        lineSpacing: 4,
        paragraphSpacing: 0,
        paragraphSpacingBefore: 0
    )

    static let proseBold = UIFont.systemFont(ofSize: fontSizeMedium, weight: UIFont.Weight.semibold)
    static let proseBoldAttributes = createParagraphAttributes(
        font: proseBold,
        lineSpacing: 4,
        paragraphSpacing: 0,
        paragraphSpacingBefore: 0
    )

    static let prose = UIFont.systemFont(ofSize: fontSizeMedium, weight: UIFont.Weight.regular)
    static let proseAttributes = createParagraphAttributes(
        font: prose,
        lineSpacing: 4,
        paragraphSpacing: 0,
        paragraphSpacingBefore: 0
    )

    static let caption = UIFont.systemFont(ofSize: fontSizeMedium - 2, weight: UIFont.Weight.regular)
    static let captionAttributes = createParagraphAttributes(
        font: caption,
        textColor: .gray,
        lineSpacing: 4,
        paragraphSpacing: 0,
        paragraphSpacingBefore: 0
    )

    private static func createAttributes(
        font: UIFont,
        textColor: UIColor = .textColor,
        kerning: CGFloat = 0,
        strikeThrough: Bool = false
    ) -> TypographyDictionary {

        var attributes: TypographyDictionary = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.kern: kerning,
            ]

        if strikeThrough {
            attributes[NSAttributedString.Key.strikethroughStyle] = 1
        }

        return attributes
    }

    private static func createParagraphAttributes(
        font: UIFont,
        textColor: UIColor = .textColor,
        lineSpacing: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        paragraphSpacingBefore: CGFloat = 0,
        alignment: NSTextAlignment = .natural,
        kerning: CGFloat = 0,
        strikeThrough: Bool = false
    ) -> TypographyDictionary {

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.paragraphSpacing = paragraphSpacing
        style.paragraphSpacingBefore = paragraphSpacingBefore
        style.alignment = alignment

        var attributes = createAttributes(
            font: font,
            textColor:
            textColor,
            kerning: kerning,
            strikeThrough: strikeThrough
        )

        attributes[NSAttributedString.Key.paragraphStyle] = style

        return attributes
    }
}


extension Action {

    var attributedButtonTitle: NSAttributedString {

        let output = NSMutableAttributedString(string: title, attributes: Typography.captionAttributes)
        output.setTextAlignment(alignment: .center)

        return output
    }

    var attributedTitle: NSAttributedString {

        return NSAttributedString(string: title, attributes: Typography.proseAttributes)
    }

    var attributedText: NSAttributedString {

        guard let subtitle = subtitle else {
            return attributedTitle
        }

        let output = NSMutableAttributedString(attributedString: attributedTitle)
        output.append(NSAttributedString(string: "\n"))
        output.append(NSAttributedString(string: subtitle, attributes: Typography.captionAttributes))

        return output
    }
}


extension Review {

    var attributedText: NSAttributedString {

        return NSAttributedString(string: text, attributes: Typography.proseAttributes)
    }

    var attributedCreatedAt: NSAttributedString {

        let output = NSMutableAttributedString(string: createdAtString, attributes: Typography.proseAttributes)
        output.setTextColor(color: .gray)

        return output
    }
}


extension User {

    var attributedName: NSAttributedString {

        return NSAttributedString(string: name, attributes: Typography.proseBoldAttributes)
    }
}
