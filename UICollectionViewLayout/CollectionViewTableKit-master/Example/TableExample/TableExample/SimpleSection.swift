//
//  SimpleSection.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import CollectionViewTableKit

enum SimpleSection: TableCollectionViewSection {

    case red
    case green
    case blue

    var numberOfItems: Int {
        switch self {
        case .red:
            return 1
        case .green:
            return 3
        case .blue:
            return 8
        }
    }

    var rowHeight: CGFloat {
        return 60
    }

    func heightForItem(at index: Int, viewWidth: CGFloat) -> CGFloat {
        return 0
    }

    func heightForHeader(viewWidth: CGFloat) -> CGFloat {
        switch self {
        case .red:
            return 0
        default:
            return 30
        }
    }

    var colsPerRow: Int {
        switch self {
        case .red:
            return 1
        case .green:
            return 3
        case .blue:
            return 5
        }
    }

    var sectionInset: UIEdgeInsets {
        switch self {
        case .red:
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }

    var minimumLineSpacing: CGFloat {
        return 0
    }

    var minimumInteritemSpacing: CGFloat {
        switch self {
        case .green:
            return 10
        default:
            return 0
        }
    }

    var title: String {
        switch self {
        case .red:
            return "red"
        case .green:
            return "green"
        case .blue:
            return "blue"
        }
    }

    var cellReuseIdentifier: String {
        switch self {
        case .red:
            return SimpleImageLabelCell.viewReuseIdentifier
        default:
            return SimpleLabelCell.viewReuseIdentifier
        }
    }
}
