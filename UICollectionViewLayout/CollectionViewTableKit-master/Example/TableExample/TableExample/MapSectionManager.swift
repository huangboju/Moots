//
//  MapSectionManager.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct MapSectionManager: SectionManager {

    typealias ItemType = MapViewModel

    var title: String?
    var items: [ItemType]
}
