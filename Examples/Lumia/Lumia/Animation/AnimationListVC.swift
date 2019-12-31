//
//  AnimationListVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class AnimationListVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "Fluid Interfaces", segue: .segue(FluidInterfacesVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "AnimatedWaveView", segue: .segue(AnimatedWaveViewVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "重力动画", segue: .segue(DynamicsCatalogMenuVC.self)))
        ]
    }
}
