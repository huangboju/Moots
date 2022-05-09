//
//  FluidInterfacesVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class FluidInterfacesVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fluid Interfaces"

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "icon_calc"), color: UIColor(hex: 0x999999), segue: .segue(CalculatorButtonInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Spring animations", icon: #imageLiteral(resourceName: "icon_spring"), color: UIColor(hex: 0x64CCF7), segue: .segue(SpringInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Flashlight button", icon: #imageLiteral(resourceName: "icon_flash"), color: UIColor(hex: 0xEDEDED), segue: .segue(FlashlightButtonInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Rubberbanding", icon: #imageLiteral(resourceName: "icon_rubber"), color: UIColor(hex: 0xFF5B50), segue: .segue(RubberbandingInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Acceleration pausing", icon: #imageLiteral(resourceName: "icon_acceleration"), color: UIColor(hex: 0x64FF8F), segue: .segue(AccelerationInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Rewarding momentum", icon: #imageLiteral(resourceName: "icon_momentum"), color: UIColor(hex: 0x73B2FF), segue: .segue(MomentumInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "FaceTime PiP", icon: #imageLiteral(resourceName: "icon_pip"), color: UIColor(hex: 0xF2F23A), segue: .segue(PipInterfaceViewController.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "Rotation", icon: #imageLiteral(resourceName: "icon_rotation"), color: UIColor(hex: 0xFF28A5), segue: .segue(RotationInterfaceViewController.self)))
            
        ]
    }
}
