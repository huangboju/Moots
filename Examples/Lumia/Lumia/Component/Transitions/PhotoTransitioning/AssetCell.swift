/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AssetCell is a basic UICollectionViewCell sublass to display a photo.
*/

import UIKit

class AssetCell: UICollectionViewCell {
    
    var assetIdentifier: String = ""
    let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        super.init(frame: frame)
        
        backgroundView = imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil;
        assetIdentifier = ""
    }
}
