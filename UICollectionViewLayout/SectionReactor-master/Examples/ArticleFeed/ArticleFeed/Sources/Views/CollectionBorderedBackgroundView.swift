//
//  CollectionBorderedBackgroundView.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 12/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class CollectionBorderedBackgroundView: UICollectionReusableView {
  override class var layerClass: AnyClass {
    return BorderedLayer.self
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    self.layer.frame.size = self.bounds.size
  }
}
