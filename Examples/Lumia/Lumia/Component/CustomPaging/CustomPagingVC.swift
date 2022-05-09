//
//  CustomPagingVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2022/5/5.
//  Copyright © 2022 黄伯驹. All rights reserved.
//

import Foundation

final class CustomPagingVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "Collection", segue: .segue(CPCollectionViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Table", segue: .segue(CPTableViewController.self))),
        ]
    }
}
