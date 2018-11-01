//
//  ImageCollectionViewGlobalHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 17/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit
import AKPFlowLayout

/// Custom UICollectionReusableView section header that serves as
/// a Global Header

class ImageCollectionViewGlobalHeader: UICollectionReusableView {
    var configStackView: UIStackView?
    var configButton: UIButton?
    var label: UILabel?
    var backgroundImageView: UIImageView?
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .darkGray
        self.clipsToBounds = true

        configureStackView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var bckgImageViewFullHeight: CGFloat = 0
    fileprivate var bckgImageViewHeightConstraint: NSLayoutConstraint?
}

extension ImageCollectionViewGlobalHeader {
    func configureStackView() {
        let backgImage = Asset.GlobalHeaderBackground.image        
        bckgImageViewFullHeight = backgImage.size.width *  backgImage.scale

        backgroundImageView = UIImageView().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = backgImage
            $0.contentMode = .scaleAspectFill
            addSubview($0)
        }
        label = UILabel().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = "About Cats and Dogs..."
            $0.setContentHuggingPriority(249, for: .horizontal)
            $0.setContentCompressionResistancePriority(500, for: .horizontal)
        }
        configButton = UIButton(type: .custom).configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsAsset), for: .normal)
            $0.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsTouchedAsset), for: .selected)
            $0.showsTouchWhenHighlighted = true
            $0.addTarget(nil, action: .showLayoutConfigOptions, for: .touchUpInside)
        }
        configStackView = UIStackView().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 10.0
            $0.layoutMargins = UIEdgeInsets(top: 0, left: $0.spacing, bottom: 0, right: $0.spacing)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.addArrangedSubview(label!)
            $0.addArrangedSubview(configButton!)
            addSubview($0)
        }
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let configStackView = configStackView,  let backgroundImageView = backgroundImageView else {return}
        
        bckgImageViewHeightConstraint = {
            $0.priority = UILayoutPriorityRequired
            return $0
        }( backgroundImageView.heightAnchor.constraint(equalToConstant: bckgImageViewFullHeight) )
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bckgImageViewHeightConstraint!,
            backgroundImageView.widthAnchor.constraint(equalTo: backgroundImageView.heightAnchor),
            
            configStackView.topAnchor.constraint(equalTo: topAnchor),
            configStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            configStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            configStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ImageCollectionViewGlobalHeader {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes = layoutAttributes as? AKPFlowLayoutAttributes,
                  let bckgImageViewHeightConstraint = bckgImageViewHeightConstraint else { return }
        bckgImageViewHeightConstraint.constant = bckgImageViewFullHeight - layoutAttributes.stretchFactor
    }
}


// MARK: - 🐞Debug configuration
extension ImageCollectionViewGlobalHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = .cyan
    }
}

// MARK: - private Selector extension for usage with the responder chain
private extension Selector {
    static let showLayoutConfigOptions = #selector(SampleImagesViewController.showLayoutConfigOptions(_:))
}


