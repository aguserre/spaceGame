//
//  MainMenuScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 29/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

var playerSelect = "player"

class MainMenuScene: SKScene {
    
    let startGame = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let options = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let gameName1 = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let gameBy = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let gameName2 = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let newGameButton = SKSpriteNode(imageNamed: "newGameButton")


    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        gameName1.text = "Space"
        gameName1.fontSize = 250
        gameName1.fontColor = .systemPink
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        gameBy.text = "By: Agustin Errecalde"
        gameBy.fontSize = 30
        gameBy.fontColor = .white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75 + gameName1.frame.size.height - gameBy.frame.size.height)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        gameName2.text = "Game"
        gameName2.fontSize = 250
        if #available(iOS 13.0, *) {
            gameName2.fontColor = .systemIndigo
        } else {
            gameName2.fontColor = .systemPink
        }
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75 - gameName1.frame.size.height)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        newGameButton.size = CGSize(width: self.size.width*0.4, height: 250)
        newGameButton.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        newGameButton.zPosition = 1
        self.addChild(newGameButton)
        
        options.text = "Settings"
        options.fontSize = 70
        options.fontColor = .cyan
        options.alpha = 0.9
        options.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.27)
        options.zPosition = 1
        options.name = "optionsBUtton"
        self.addChild(options)
        
        let playerImage = SKSpriteNode(imageNamed: playerSelect)
        playerImage.size = CGSize(width: 250, height: 250)
        playerImage.position = CGPoint(x: self.size.width/2, y: self.size.height*0.15)
        playerImage.zPosition = 1
        playerImage.zRotation = CGFloat(-90)
        self.addChild(playerImage)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if newGameButton.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if options.contains(pointOfTouch){
                let sceneToMoveTo = OptionsScnene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
}
