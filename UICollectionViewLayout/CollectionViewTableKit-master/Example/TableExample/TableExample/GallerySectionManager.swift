//
//  GallerySectionManager.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct GallerySectionManager: SectionManager {

    typealias ItemType = GalleryViewModel

    var title: String?
    var items: [ItemType]
}
