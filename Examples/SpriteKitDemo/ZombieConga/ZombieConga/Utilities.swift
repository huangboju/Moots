//
//  Utilities.swift
//  ZombieConga
//
//  Created by 黄伯驹 on 2019/2/24.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ZPositions: CGFloat {
    case background = -1.0, cat = 50.0, enemy = 51.0, zombie = 100.0, hud = 150.0
}

extension SKNode {
    
    func setZPosition(_ value: ZPositions) {
        zPosition = value.rawValue
    }
}
