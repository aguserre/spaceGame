//
//  GameOverScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 29/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let restartLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let mainMenu = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let winLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")

    var enemyWinName = ""
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverImage = SKSpriteNode(imageNamed: "game-over")
        gameOverImage.size = CGSize(width: self.size.width*0.5, height: 650)
        gameOverImage.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        gameOverImage.zPosition = 1
        self.addChild(gameOverImage)
        
        let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 90
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 90
        highScoreLabel.fontColor = .systemPink
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.50)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 70
        restartLabel.fontColor = .cyan
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        mainMenu.text = "Main Menu"
        mainMenu.fontSize = 70
        mainMenu.fontColor = .systemYellow
        mainMenu.position = CGPoint(x: self.size.width/2, y: self.size.height*0.30)
        mainMenu.zPosition = 1
        self.addChild(mainMenu)
        
        let enemyWin = SKSpriteNode(imageNamed: enemyWinName)
        enemyWin.size = CGSize(width: 300, height: 300)
        enemyWin.position = CGPoint(x: self.size.width/2, y: self.size.height*0.15)
        enemyWin.zPosition = 1
        enemyWin.zRotation = CGFloat(-90)
        self.addChild(enemyWin)
        
        winLabel.text = "Winner: \(enemyWinName)"
        winLabel.fontSize = 50
        winLabel.fontColor = .lightGray
        winLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.15 - enemyWin.frame.size.height/2)
        winLabel.zPosition = 1
        self.addChild(winLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if mainMenu.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "musicOff") {
            backingAudio.play()
        }
    }
    
}
