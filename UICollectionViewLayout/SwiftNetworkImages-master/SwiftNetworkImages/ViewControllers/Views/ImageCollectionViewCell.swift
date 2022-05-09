//
//  ImageCollectionViewCell.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/**
    A custom UICollectionViewCell that presents an image with caption,
    based on ovservable data from its ImageViewModel
*/

@IBDesignable class ImageCollectionViewCell: UICollectionViewCell {
    var roundedCornersView: RoundedCornersView?
    var imageView: UIImageView?
    var captionLabel: UILabel?

    var imageVewModel: ImageViewModel? {
        didSet {
            guard let imageVewModel = imageVewModel else { return }

            _loadingIndicator.startAnimating()
            _loadingIndicator.isHidden = false
            
            imageVewModel.imageCaption.observe { [weak self] text in
                DispatchQueue.main.async { self?.captionLabel?.text = text }
            }
            
            imageVewModel.image.observe { [weak self] image in
                DispatchQueue.main.async { self?.imageView?.image = image }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self?._loadingIndicator.stopAnimating()
                    self?._loadingIndicator.isHidden = true
                }
            }
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        roundedCornersView = RoundedCornersView().configure {
            $0.cornerRadius = 4.0
            $0.backgroundColor = .lightText
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView = UIImageView().configure {
            $0.contentMode = .scaleAspectFill
            $0.addSubview(_loadingIndicator)
            roundedCornersView?.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        captionLabel = UILabel().configure {
            $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
            $0.text = "Image Caption"
            $0.textAlignment = .center
            roundedCornersView?.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
            $0.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        }
        // _configureForDebug()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - 🕶Private
    fileprivate lazy var _loadingIndicator: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.color = .darkGray
        return $0
    }( UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge) )
}

extension ImageCollectionViewCell {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let roundedCornersView = roundedCornersView,
                  let captionLabel = captionLabel, let imageView = imageView else {return}
        
        let layoutGuide = UILayoutGuide()
        roundedCornersView.addLayoutGuide(layoutGuide)
        
        NSLayoutConstraint.activate([
            roundedCornersView.topAnchor.constraint(equalTo: contentView.topAnchor),
            roundedCornersView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            roundedCornersView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roundedCornersView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: roundedCornersView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: roundedCornersView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: roundedCornersView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: roundedCornersView.heightAnchor,
                                                                                    multiplier: 0.90),
            _loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            _loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            layoutGuide.bottomAnchor.constraint(equalTo: roundedCornersView.bottomAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: roundedCornersView.leadingAnchor),
            layoutGuide.trailingAnchor.constraint(equalTo: roundedCornersView.trailingAnchor),
            layoutGuide.heightAnchor.constraint(equalTo: roundedCornersView.heightAnchor,
                                                                                    multiplier: 0.10),            
            captionLabel.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            captionLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: roundedCornersView.layoutMarginsGuide.leadingAnchor)
        ])
    }
}

// MARK: - 🐞Debug configuration
extension ImageCollectionViewCell: DebugConfigurable {
    func _configureForDebug() {
        guard let roundedCornersView = roundedCornersView,
            let captionLabel = captionLabel, let imageView = imageView else {return}
        
        contentView.backgroundColor = .cyan
        roundedCornersView.backgroundColor = .green
        imageView.backgroundColor = .red
        captionLabel.backgroundColor = .yellow
    }
}
