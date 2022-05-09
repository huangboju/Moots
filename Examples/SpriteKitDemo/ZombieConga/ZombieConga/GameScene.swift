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
    let backgroundMusicPlayer: BackgroundMusicPlayer = {
        do {
            return try BackgroundMusicPlayer(filename: .backgroundMusic)
        } catch {
            print(error)
            fatalError()
        }
    }()

    private lazy var zombie: SKSpriteNode = {
        let zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.setZPosition(.zombie)
        return zombie
    }()
    
    private lazy var catsLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: .glimstick)
        node.fontColor = .black
        node.fontSize = 100.0
        node.horizontalAlignmentMode = .right
        node.verticalAlignmentMode = .bottom
        node.position = CGPoint(x: self.playableRect.size.halfWidth - 20.0, y: -self.playableRect.size.halfHeight + 20.0)
        node.setZPosition(.hud)
        return node
    }()
    
    lazy var livesLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: .glimstick)
        node.fontColor = .black
        node.fontSize = 100.0
        node.horizontalAlignmentMode = .left
        node.verticalAlignmentMode = .bottom
        node.position = CGPoint(x: -self.playableRect.size.halfWidth + 20.0, y: -self.playableRect.size.halfHeight + 20.0)
        node.setZPosition(.hud)
        return node
    }()

    let playableRect: CGRect
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    private let cameraMovePointsPerSec: CGFloat = 200.0
    var velocity = CGPoint.zero
    var lastTouchLocation: CGPoint?
    let zombieRotateRadiansPerSec = 4.0 * π
    private let enemyMoveDuration = 2.0
    var gameOver = false
    var lives = 5
    let flipHorizontalTransitionDuration: TimeInterval = 0.5
    var invincible = false
    
    let catCollisionSound = SKAction.playSoundFileNamed(
        "hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound = SKAction.playSoundFileNamed(
        "hitCatLady.wav", waitForCompletion: false)

    let zombieAnimation: SKAction
    
    var cameraRect: CGRect {
        guard let camera = camera else { return .zero }
        let x = camera.position.x - size.halfWidth + (size.width - playableRect.width) / 2.0
        let y = camera.position.y - size.halfHeight + (size.height - playableRect.height) / 2.0
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
    
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
    
    var background: SKSpriteNode {
        let node = SKSpriteNode()
        node.name = Strings.background.rawValue
        node.anchorPoint = .zero
        node.position = .zero
        node.setZPosition(.background)
        
        let background1 = SKSpriteNode(imageNamed: .background1)
        background1.anchorPoint = .zero
        background1.position = .zero
        node.addChild(background1)
        
        let background2 = SKSpriteNode(imageNamed: .background2)
        background2.anchorPoint = .zero
        background2.position = CGPoint(x: background1.size.width, y: 0.0)
        node.addChild(background2)
        
        node.size = CGSize(width: background1.size.width + background2.size.width, height: background1.size.height)
        return node
    }
    
    override func didMove(to view: SKView) {
        
        configure()
        

        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                }, SKAction.wait(forDuration: enemyMoveDuration + 0.25)])))
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnCat()
                }, SKAction.wait(forDuration: 1.0)])))
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
        rotate(zombie, direction: velocity)
        //        }
        
        moveTrain()
        moveCamera()
        livesLabel.text = "Lives: \(self.lives)"
    }
    
    private func configure() {
        backgroundMusicPlayer.play()
        backgroundColor = .black
        
        for i in 0...1 {
            let background = self.background
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0.0)
            addChild(background)
        }
        
        addChild(zombie)
//        startZombieAnimation()
        
        let camera = SKCameraNode()
        addChild(camera)
        camera.position = CGPoint(x: size.halfWidth, y: size.halfHeight)
        camera.addChild(livesLabel)
        
        catsLabel.text = "Cats: 0"
        camera.addChild(catsLabel)
        
        self.camera = camera
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
    
    override func didEvaluateActions() {
        checkZombieBounds()
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
        startZombieAnimation()
        let offset = location - zombie.position
        velocity = offset.normalized * zombieMovePointsPerSec
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
        run(catCollisionSound)
        cat.name = Strings.train.rawValue
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0.0
        cat.run(SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2))
    }

    func zombieHit(enemy: SKSpriteNode) {
        guard invincible == false else { return }
        invincible = true
        run(enemyCollisionSound)
        loseCats()
        lives -= 1
        let wait = SKAction.wait(forDuration: 0.2)
        
        zombie.run(SKAction.repeat(SKAction.sequence([
            SKAction.hide(), wait,
            SKAction.unhide(), wait
            ]), count: 10)) { [weak self] in
                self?.invincible = false
        }
    }

    func checkCollisions() {
        var enemies = [SKSpriteNode]()
        var cats = [SKSpriteNode]()
        
        enumerateChildNodes(withName: .enemy) { [weak self] node, _ in
            guard let `self` = self,
                let enemy = node as? SKSpriteNode,
                node.frame.insetBy(dx: 20.0, dy: 20.0).intersects(self.zombie.frame)
                else { return }
            
            enemies.append(enemy)
        }
        
        enumerateChildNodes(withName: .cat) { [weak self] node, _ in
            guard let `self` = self,
                let cat = node as? SKSpriteNode,
                node.frame.intersects(self.zombie.frame)
                else { return }
            
            cats.append(cat)
        }

        enemies.forEach { zombieHit(enemy: $0) }
        cats.forEach { zombieHit(cat: $0) }
    }
    
    func loseCats() {
        var loseCount = 0
        
        enumerateChildNodes(withName: .train) { node, stop in
            var randomPosition = node.position
            randomPosition.x += CGFloat.random(min: -100.0, max: 100.0)
            randomPosition.y += CGFloat.random(min: -100.0, max: 100.0)
            
            node.name = nil
            
            node.run(SKAction.sequence([
                SKAction.group([
                    SKAction.rotate(byAngle: .pi * 4.0, duration: 1.0),
                    SKAction.move(to: randomPosition, duration: 1.0),
                    SKAction.scale(to: 0.0, duration: 1.0)
                    ]),
                SKAction.removeFromParent()
                ]))
            
            loseCount += 1
            
            if loseCount >= 2 {
                stop[0] = true
            }
        }
    }

    func checkZombieBounds() {
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        let topRight = CGPoint(x: cameraRect.maxX, y: cameraRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = abs(velocity.x)
            
            if velocity.x == 0 {
                startZombieAnimation()
            }
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
    
    func moveCamera() {
        camera?.position += CGPoint(x: cameraMovePointsPerSec, y: 0.0) * CGFloat(dt)
        
        enumerateChildNodes(withName: .background) { [weak self] node, _ in
            guard let `self` = self,
                let background = node as? SKSpriteNode
                else { return }
            
            if background.position.x + background.size.width < self.cameraRect.minX {
                background.position = CGPoint(x: background.position.x + background.size.width * 2.0, y: background.position.y)
            }
        }
    }
    
    func moveTrain() {
        var trainCount = 0
        var targetPosition = zombie.position
        let duration: TimeInterval = 0.3
        
        enumerateChildNodes(withName: .train) { node, _ in
            trainCount += 1
            
            if node.hasActions() == false {
                let move = (targetPosition - node.position).normalized * self.zombieMovePointsPerSec * CGFloat(duration)
                node.run(SKAction.moveBy(x: move.x, y: move.y, duration: duration))
                //                node.run(SKAction.move(to: targetPosition, duration: duration))
            }
            
            targetPosition = node.position
        }
        
        print("trainCount = \(trainCount)")
        catsLabel.text = "Cats: \(trainCount)"
        
        if trainCount >= 15 && gameOver == false {
            backgroundMusicPlayer.stop()
            gameOver = true
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: flipHorizontalTransitionDuration)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
}
