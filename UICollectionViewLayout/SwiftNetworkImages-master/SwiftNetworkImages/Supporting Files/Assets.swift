//
//  Assets.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Enumed images names from the project Asset Catalog 

enum Asset: String {
    case LayoutConfigOptionsAsset = "LayoutConfigOptions"
    case LayoutConfigOptionsTouchedAsset = "LayoutConfigOptionsTouched"
    case GlobalHeaderBackground = "GlobalHeaderBackground"
    
    var image: UIImage {
        return UIImage(asset: self)!
    }
}
