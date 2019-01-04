//
//  TopActionsSectionManager.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import Foundation

struct TopActionsSectionManager: SectionManager {

    typealias ItemType = TopActionViewModel

    var title: String?
    var items: [ItemType]
}
