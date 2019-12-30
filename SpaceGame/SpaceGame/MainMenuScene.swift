//
//  MainMenuScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 29/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    let startGame = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameBy.text = "Agustin Errecalde"
        gameBy.fontSize = 50
        gameBy.fontColor = .white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameName1.text = "Space"
        gameName1.fontSize = 175
        gameName1.fontColor = .white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameName2.text = "Game"
        gameName2.fontSize = 175
        gameName2.fontColor = .white
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = .white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if startGame.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
}
