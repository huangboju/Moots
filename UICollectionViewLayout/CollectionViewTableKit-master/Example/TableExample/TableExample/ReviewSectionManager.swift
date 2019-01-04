//
//  ReviewSectionManager.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct ReviewSectionManager: SectionManager {

    typealias ItemType = ReviewViewModel

    var title: String?
    var items: [ItemType]
}
