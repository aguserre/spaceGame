//
//  OptionsScene.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 31/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import Foundation
import SpriteKit

var difficulty = ""

class OptionsScnene: SKScene {

    let settingsLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let closeOptions = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let difficultyButton = SKSpriteNode(imageNamed: "difficultyButton")
    let difficultyLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let music = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")



    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        settingsLabel.text = "Settings"
        settingsLabel.fontSize = 200
        if #available(iOS 13.0, *) {
            settingsLabel.fontColor = .systemIndigo
        } else {
            settingsLabel.fontColor = .systemPink
        }
        settingsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        settingsLabel.zPosition = 1
        self.addChild(settingsLabel)
        
        difficultyButton.size = CGSize(width: self.size.width*0.4, height: 160)
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
        
        if userDefaults.bool(forKey: "musicOff") {
            music.text = "Music Off"
        } else {
            music.text = "Music On"
        }
        music.fontSize = 60
        music.fontColor = .white
        music.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        music.zPosition = 1
        self.addChild(music)
        
        closeOptions.text = "Save"
        closeOptions.fontSize = 80
        closeOptions.fontColor = .white
        closeOptions.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        closeOptions.zPosition = 1
        self.addChild(closeOptions)
        
        
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
           
            if music.contains(pointOfTouch){
                setUpMusic()
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
        
        if music.text == "Music On"{
            music.text = "Music Off"
            backingAudio.stop()
            userDefaults.set(true, forKey: "musicOff")
        } else {
            music.text = "Music On"
            backingAudio.play()
            userDefaults.set(false, forKey: "musicOff")
        }
        userDefaults.synchronize()
    }
    
}
