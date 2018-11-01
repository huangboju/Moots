//
//  UIImage+Assets.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 11/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Adds instantiation with the enum-ed name of an Asset Catalog image

extension UIImage {
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
