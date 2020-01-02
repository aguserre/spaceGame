//
//  GameScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 28/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")

    let livesLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    var livesNumber = 3
    
    let LevelLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    var levelNumber = 0
    
    var enemies = ["enemy1","enemy2","enemy3"]
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600
    var enemyWinName = ""
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let Enemy: UInt32 = 0b100 //4
        static let Live: UInt32 = 0b101 //5
    }
    
    var gameArea: CGRect
    override init (size: CGSize) {
        let iphoneModel = UIDevice().type
        var maxAspectRatio : CGFloat = 0
        
        switch iphoneModel {
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            maxAspectRatio = 19.5/9
        case .iPhoneSE, .iPhone6, .iPhone6S, .iPhone6Plus, .iPhone6SPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus:
            maxAspectRatio = 16.0/9
        default:
            maxAspectRatio = 16.0/9
        }
        
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let player = SKSpriteNode(imageNamed: playerSelect)
    let bulletSound = SKAction.playSoundFileNamed("shotSound.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    let newLifeSound = SKAction.playSoundFileNamed("newLifeSound.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false)
    let enemyHitSound = SKAction.playSoundFileNamed("hitEnemySound.mp3", waitForCompletion: false)

    let tapToStartLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    
    enum gameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        //SetUp background
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5,
                                             y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height * CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        //SetUp Player
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height*0.6)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Live
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.22, y: self.size.height * 0.94 + scoreLabel.frame.size.height*4)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.94 + livesLabel.frame.size.height*4)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.92, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        LevelLabel.text = "Level: 1"
        LevelLabel.fontSize = 50
        LevelLabel.fontColor = SKColor.systemPink
        LevelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        LevelLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.95 + LevelLabel.frame.size.height*4)
        LevelLabel.zPosition = 100
        self.addChild(LevelLabel)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = .white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background") { background, stop in
            
            if self.currentGameState == .inGame{
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    func startGame(){
        
        currentGameState = .inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteActionn = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteActionn])
        
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.15, duration: 0.3)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenAction,startLevelAction])
        player.run(startGameSequence)
    }
    
    func loseAlife (){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber < 0{
            runGameOver()
        }
    }
    
    func addLife(){
        livesNumber += 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([newLifeSound ,scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 3 ||    //level 2
            gameScore == 7 ||   //level 3
            gameScore == 15 ||  //level 4
            gameScore == 25 ||  //level 5
            gameScore == 40 {   //level 6
                LevelLabel.text = "Level: \(levelNumber)"
                startNewLevel()
        }
    }
    
    func changeEnemies(){
        enemies.removeAll()
        switch levelNumber {
        case 1:
            enemies = ["enemy1","enemy2","enemy3"]
        case 2:
            enemies = ["enemy4"]
        case 3:
            enemies = ["enemy5"]
        case 4:
            enemies = ["enemy6"]
        case 5:
            enemies = ["enemy7"]
        default:
            enemies = ["enemy1","enemy2","enemy3","enemy4" ,"enemy5" ,"enemy6", "enemy7"]
        }
    }
    
    func runGameOver(){
        
        currentGameState = .afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") { bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") { enemy, stop in
            enemy.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Live") { live, stop in
            live.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        backingAudio.stop()
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,gameOverSound, waitToChangeScene,changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //Player hit the enemy
            
            if livesNumber <= 0 {
                if body1.node != nil{
                    spawnExplosion(spawnPosition: body1.node!.position)
                }
                if body2.node != nil {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                
                runGameOver()
            } else {
                livesNumber = 0
                livesLabel.text = "Lives: 0"
                player.run(enemyHitSound)
                body2.node?.removeFromParent()
            }
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Live {
            //Bullet hit life
            addLife()
            if body2.node != nil {
                //Add sound live add
            }
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy  && (body2.node?.position.y)! < self.size.height{
            //bullet hit the enemy
            addScore()
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
                        
        } else {
            return
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let explosionSequence = SKAction.sequence([explosionSound])
        explosion.run(explosionSequence)
    }
    
    func startNewLevel() {
        levelNumber += 1
        if self.action(forKey: "spawnEnemies") != nil {
            self.removeAction(forKey: "spawnEnemies")
        }
        if self.action(forKey: "spawnLives") != nil {
            self.removeAction(forKey: "spawnLives")
        }
        
        
        var levelDuration = TimeInterval()
        let liveSpawnDuration: TimeInterval = 5

        if UserDefaults.standard.bool(forKey: "hard"){
            
            switch levelNumber {
                case 1: levelDuration = 2
                case 2: levelDuration = 1.5
                case 3: levelDuration = 1
                case 4: levelDuration = 0.7
                case 5: levelDuration = 0.4
                default: levelDuration = 0.2
                    print("Cannont find level")
            }
            changeEnemies()
            
        } else {
            switch levelNumber {
                case 1: levelDuration = 3
                case 2: levelDuration = 2
                case 3: levelDuration = 1
                case 4: levelDuration = 0.8
                case 5: levelDuration = 0.5
                default: levelDuration = 0.2
                    print("Cannont find level")
            }
            changeEnemies()
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let spawnLives = SKAction.run(spawnLive)
        
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let waitToSpawnLives = SKAction.wait(forDuration: liveSpawnDuration)
        
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let liveSpawnSequence = SKAction.sequence([waitToSpawnLives, spawnLives])
        
        let spawnForEver = SKAction.repeatForever(spawnSequence)
        let spawnLivesForEver = SKAction.repeatForever(liveSpawnSequence)
        
        self.run(spawnForEver, withKey: "spawnEnemies")
        self.run(spawnLivesForEver, withKey: "spawnLives")
    }
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "torpedo")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height*1.5)
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.Live
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(random()) * (max - min) + min
    }
    
    func spawnLive(){
        let randomXStart = randomNumber(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = randomNumber(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
                
        let live = SKSpriteNode(imageNamed: "live")
        live.name = "Live"
        live.setScale(2)
        live.position = startPoint
        live.zPosition = 2
        live.physicsBody = SKPhysicsBody(rectangleOf: live.size)
        live.physicsBody?.affectedByGravity = false
        live.physicsBody?.categoryBitMask = PhysicsCategories.Live
        live.physicsBody?.collisionBitMask = PhysicsCategories.Enemy | PhysicsCategories.Bullet
        live.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        self.addChild(live)
        
        //Live velocity
        let moveLive = SKAction.move(to: endPoint, duration: 3)
        let deleteLive = SKAction.removeFromParent()
        let liveSequence = SKAction.sequence([moveLive, deleteLive])
        
        if currentGameState == .inGame{
            live.run(liveSequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        live.zRotation = amountToRotate
    }
    
    func spawnEnemy(){
        let randomXStart = randomNumber(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = randomNumber(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        enemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemies) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: enemies[0])
        enemyWinName = enemies[0]
        enemy.name = "Enemy"
        enemy.setScale(3)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.Live
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        //Enemy velocity
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseAlifeAction = SKAction.run(loseAlife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseAlifeAction])
        
        if currentGameState == .inGame{
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == .preGame{
            startGame()
        } else if currentGameState == .inGame {
            fireBullet()
        }
        
        let moveOnToScreenActionLevel = SKAction.moveTo(y: self.size.height*0.93, duration: 0.3)
        LevelLabel.run(moveOnToScreenActionLevel)
    }
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == .inGame{
                player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.enemyWinName = self.enemyWinName
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(sceneToMoveTo, transition: transition)
    }
}

