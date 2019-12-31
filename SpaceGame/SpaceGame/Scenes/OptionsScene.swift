//
//  OptionsScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 31/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsScnene: SKScene {

    let settingsLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let closeOptions = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let difficultyButton = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let difficultyLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let musicButton = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let musicLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let choosePlayerButton = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    
    var characterArray = ["player", "enemy1", "enemy2","enemy3","enemy4","enemy5","enemy6" ,"enemy7"]
    var selector = -1
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        settingsLabel.text = "Settings"
        settingsLabel.fontSize = 200
        settingsLabel.fontColor = .cyan
        settingsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        settingsLabel.zPosition = 1
        self.addChild(settingsLabel)
        
        difficultyButton.text = "Difficulty"
        difficultyButton.fontSize = 80
        difficultyButton.fontColor = .systemPurple
        difficultyButton.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        difficultyButton.zPosition = 1
        self.addChild(difficultyButton)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hard") {
            difficultyLabel.text = "Hard"
        } else {
            difficultyLabel.text = "Easy"
        }
        difficultyLabel.fontSize = 60
        difficultyLabel.fontColor = .white
        difficultyLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65 - difficultyButton.frame.size.height)
        difficultyLabel.zPosition = 1
        self.addChild(difficultyLabel)
        
        musicButton.text = "Music On/Off"
        musicButton.fontSize = 80
        musicButton.fontColor = .systemPink
        musicButton.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.50)
        musicButton.zPosition = 1
        self.addChild(musicButton)
        
        if userDefaults.bool(forKey: "musicOff") {
            musicLabel.text = "Off"
        } else {
            musicLabel.text = "On"
        }
        musicLabel.fontSize = 60
        musicLabel.fontColor = .white
        musicLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.50 - musicButton.frame.size.height)
        musicLabel.zPosition = 1
        self.addChild(musicLabel)
        
        closeOptions.text = "Save"
        closeOptions.fontSize = 60
        closeOptions.fontColor = .white
        closeOptions.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.15)
        closeOptions.zPosition = 1
        self.addChild(closeOptions)
        
        choosePlayerButton.text = "Choose ship"
        choosePlayerButton.fontSize = 80
        choosePlayerButton.fontColor = .systemPink
        choosePlayerButton.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        choosePlayerButton.zPosition = 1
        self.addChild(choosePlayerButton)
        
        changePlayer()
    }
    
    func setPlayer(){
        let playerSelected = SKSpriteNode(imageNamed: playerSelect)
        playerSelected.name = "ship"
        playerSelected.size = CGSize(width: 250, height: 250)
        playerSelected.position = CGPoint(x: self.size.width/2, y: self.size.height*0.32 - choosePlayerButton.frame.size.height)
        playerSelected.zPosition = 1
        playerSelected.zRotation = CGFloat(-90)
        self.addChild(playerSelected)
    }
    
    func changePlayer(){
        if selector < 7{
            selector += 1
        } else {
            selector = 0
        }
        playerSelect = characterArray[selector]
        
        if let child = self.childNode(withName: "ship") as? SKSpriteNode {
            child.removeFromParent()
        }
        setPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if closeOptions.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if difficultyButton.contains(pointOfTouch){
                changeDifficulty()
            }
           
            if musicButton.contains(pointOfTouch){
                setUpMusic()
            }
            if choosePlayerButton.contains(pointOfTouch){
                changePlayer()
            }
        }
    }
    
    func changeDifficulty(){
        let userDefaults = UserDefaults.standard
        
        if difficultyLabel.text == "Easy"{
            difficultyLabel.text = "Hard"
            userDefaults.set(true, forKey: "hard")
        } else {
            difficultyLabel.text = "Easy"
            userDefaults.set(false, forKey: "hard")
        }
        userDefaults.synchronize()
    }
    
    func setUpMusic(){
        let userDefaults = UserDefaults.standard
        
        if musicLabel.text == "On"{
            musicLabel.text = "Off"
            backingAudio.stop()
            userDefaults.set(true, forKey: "musicOff")
        } else {
            musicLabel.text = "On"
            backingAudio.play()
            userDefaults.set(false, forKey: "musicOff")
        }
        userDefaults.synchronize()
    }
    
}
