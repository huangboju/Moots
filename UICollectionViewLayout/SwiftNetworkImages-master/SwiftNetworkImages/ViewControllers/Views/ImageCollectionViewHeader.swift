//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// A custom UICollectionReusableView section header


class ImageCollectionViewHeader: UICollectionReusableView {
    var sectionHeaderLabel: UILabel?
    var sectionHeaderText: String? {
        didSet {
            sectionHeaderLabel?.text = sectionHeaderText
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sectionHeaderLabel = UILabel().configure {
            $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            $0.text = "Section Header"
            $0.textAlignment = .center
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        backgroundColor = .lightGray
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let sectionHeaderLabel = sectionHeaderLabel else {return}
        NSLayoutConstraint.activate([
            sectionHeaderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            sectionHeaderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sectionHeaderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - 🐞Debug configuration
extension ImageCollectionViewHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = .magenta
    }
}


