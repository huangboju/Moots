//
//  CollectionViewViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import Foundation

protocol CollectionViewViewModel: SectionRepresentable, CellRepresentable {

    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
}
