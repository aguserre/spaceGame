//
//  GameScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 28/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        //SetUp background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //SetUp Player
        let player = SKSpriteNode(imageNamed: "player")
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        
        
    }
        
}
