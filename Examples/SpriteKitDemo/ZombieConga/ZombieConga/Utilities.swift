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

enum Strings: String {
    case animation, background, background1, background2, backgroundMusic = "backgroundMusic.mp3", cat, displayStats = "DISPLAY_STATS", enemy, glimstick = "Glimstick", hitCat = "hitCat.wav", hitCatLady = "hitCatLady.wav", loseSound = "lose.wav", mainMenu = "MainMenu", train, winSound = "win.wav", youLose = "YouLose", youWin = "YouWin", zombie, zombie1
}


extension SKSpriteNode {
    
    convenience init(imageNamed name: Strings) {
        self.init(imageNamed: name.rawValue)
    }
    
    func action(forKey key: Strings) -> SKAction? {
        return action(forKey: key.rawValue)
    }
    
    func run(_ action: SKAction, withKey key: Strings) {
        run(action, withKey: key.rawValue)
    }
    
    func removeAction(forKey key: Strings) {
        removeAction(forKey: key.rawValue)
    }
}

extension SKNode {
    
    func enumerateChildNodes(withName name: Strings, using block: @escaping (SKNode, UnsafeMutablePointer<ObjCBool>) -> Void) {
        enumerateChildNodes(withName: name.rawValue, using: block)
    }
}

extension SKLabelNode {
    
    convenience init(fontNamed fontName: Strings) {
        self.init(fontNamed: fontName.rawValue)
    }
}

extension CGSize {
    
    var halfWidth: CGFloat {
        return width / 2.0
    }
    
    var halfHeight: CGFloat {
        return height / 2.0
    }
}

extension SKAction {
    
    static func playSoundFileNamed(_ soundFile: Strings, waitForCompletion wait: Bool) -> SKAction {
        return playSoundFileNamed(soundFile.rawValue, waitForCompletion: wait)
    }
}
