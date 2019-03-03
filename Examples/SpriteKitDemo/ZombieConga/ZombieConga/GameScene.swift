//
//  GameScene.swift
//  ZombieConga
//
//  Created by 黄伯驹 on 2019/2/23.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private lazy var zombie: SKSpriteNode = {
        let zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.setZPosition(.zombie)
        return zombie
    }()

    let playableRect: CGRect
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    var lastTouchLocation: CGPoint?
    let zombieRotateRadiansPerSec = 4.0 * π
    
    let zombieAnimation: SKAction
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRatio // 2
        let playableMargin = (size.height-playableHeight)/2.0 // 3
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight) // 4
        
        // 1
        let textures = [1,2,3,4,2,1].map { SKTexture(imageNamed: "zombie\($0)") }
        // 4
        zombieAnimation = SKAction.animate(with: textures,
                                           timePerFrame: 0.1)
        super.init(size: size) // 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let background = SKSpriteNode(imageNamed: "background1")
        addChild(background)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(zombie)
        startZombieAnimation()

        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                }, SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnCat()
                }, SKAction.wait(forDuration: 1.0)])))
        
        debugDrawPlayableArea()
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(x: size.width + enemy.size.width/2,
                                 y: CGFloat.random(
            min: playableRect.minY + enemy.size.height/2,
            max: playableRect.maxY - enemy.size.height/2))
        enemy.setZPosition(.enemy)
        addChild(enemy)
        
        let actionMove =
            SKAction.moveTo(x: -enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
        
//        // 1
//        let actionMidMove = SKAction.moveBy(
//            x: -size.width/2-enemy.size.width/2,
//            y: -playableRect.height/2 + enemy.size.height/2,
//            duration: 1.0)
//        let actionMove = SKAction.moveBy(
//            x: -size.width/2-enemy.size.width/2,
//            y: playableRect.height/2 - enemy.size.height/2,
//            duration: 1.0)
//        // 3
//        let wait = SKAction.wait(forDuration: 0.25)
//        let logMessage = SKAction.run() {
//            print("Reached bottom!")
//        }
//        let halfSequence = SKAction.sequence(
//            [actionMidMove, logMessage, wait, actionMove])
//        let sequence = SKAction.sequence(
//            [halfSequence, halfSequence.reversed()])
//        let repeatAction = SKAction.repeatForever(sequence)
//        enemy.run(repeatAction)
    }
    
    func spawnCat() {
        // 1
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(
            x: CGFloat.random(min: playableRect.minX,
                              max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY,
                              max: playableRect.maxY))
        cat.setScale(0)
        cat.setZPosition(.cat)
        cat.zRotation = -π / 16.0
        
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])

        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence(
            [scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        addChild(cat)
        // 2
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
//        if let lastTouchLocation = lastTouchLocation,
//            (lastTouchLocation - zombie.position).length <= CGFloat(dt) * zombieMovePointsPerSec {
//            zombie.position = lastTouchLocation
//            velocity = .zero
//            stopZombieAnimation()
//        } else {
            move(sprite: zombie, velocity: velocity)
            boundsCheckZombie()
            rotate(zombie, direction: velocity)
//        }
        checkCollisions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation)
        lastTouchLocation = touchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation)
    }
    
    func sceneTouched(_ touchLocation:CGPoint) {
        moveZombieToward(touchLocation)
    }

    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = velocity * CGFloat(dt)
        print("Amount to move: \(amountToMove)")
        // 2
        sprite.position += amountToMove
    }
    
    func rotate(_ sprite: SKSpriteNode, direction: CGPoint) {
        let shortest = shortestAngleBetween(sprite.zRotation, and: velocity.angle)
        let rotation = min(zombieRotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign * rotation
    }

    func moveZombieToward(_ location: CGPoint) {
        let offset = CGPoint(x: location.x - zombie.position.x,
                             y: location.y - zombie.position.y)
        let length = sqrt(offset.x * offset.x + offset.y * offset.y)
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec,
                           y: direction.y * zombieMovePointsPerSec)
    }
    
    func startZombieAnimation() {
        guard zombie.action(forKey: "animation") == nil else {
            return
        }
        zombie.run(
            SKAction.repeatForever(zombieAnimation),
            withKey: "animation")
    }

    func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    func zombieHit(cat: SKSpriteNode) {
        cat.removeFromParent()
    }

    func zombieHit(enemy: SKSpriteNode) {
        enemy.removeFromParent()
    }

    func checkCollisions() {
        var hitCats: [SKSpriteNode] = []
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! SKSpriteNode
            if cat.frame.intersects(self.zombie.frame) {
                hitCats.append(cat)
            }
        }

        hitCats.forEach { zombieHit(cat: $0) }

        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy") { node, _ in
            let enemy = node as! SKSpriteNode
            if node.frame.insetBy(dx: 20, dy: 20).intersects(
                self.zombie.frame) {
                hitEnemies.append(enemy)
            }
        }

        hitEnemies.forEach { zombieHit(enemy: $0) }
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        shape.zPosition = 200
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
}
