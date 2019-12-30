//
//  LaunchScreenCustom.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 30/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

var counter = 0

class LaunchScreenCustom: SKScene {
    let iconLaunchScreen = SKSpriteNode(imageNamed: "player")
    let background = SKSpriteNode(imageNamed: "background")

    override func didMove(to view: SKView) {
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        iconLaunchScreen.size = CGSize(width: 300, height: 300)
        iconLaunchScreen.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        iconLaunchScreen.zPosition = 1
        iconLaunchScreen.zRotation = CGFloat(-90)
        self.addChild(iconLaunchScreen)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        let scaleTimes = SKAction.repeat(scaleSequence, count: 5)
        iconLaunchScreen.run(scaleTimes) {
            self.goToMainMenu()
        }
        
        let loadingLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        loadingLabel.text = "Loading..."
        loadingLabel.fontSize = 90
        loadingLabel.fontColor = .white
        loadingLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - iconLaunchScreen.size.height)
        loadingLabel.zPosition = 1
        self.addChild(loadingLabel)
        
    }
    
    func goToMainMenu(){
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(sceneToMoveTo, transition: transition)
    }
    
}
