//
//  PlaceActionsSection.swift
//  TableExample
//
//  Created by Malte Schonvogel on 08.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import Foundation

struct PlaceActionsSectionManager: SectionManager {

    typealias ItemType = PlaceActionViewModel

    var title: String?
    var items: [ItemType]
}
