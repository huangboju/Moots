//
//  DynamicsCatalogMenuVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class DynamicsCatalogMenuVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "Gravity", segue: .segue(GravityVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Collision + Gravity", segue: .segue(CollisionGravityVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Attachments + Gravity", segue: .segue(AttachmentsVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Collision + Gravity + Spring", segue: .segue(CollisionsGravitySpringVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Snap", segue: .segue(SnapVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Instantaneous Push + Collision", segue: .segue(InstantaneousPushVC.self)))
        ]
    }
}
