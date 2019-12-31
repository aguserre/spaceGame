//
//  GameViewController.swift
//  SpaceGame
//
//  Created by Agustin Errecalde on 28/12/2019.
//  Copyright © 2019 nistsugaDev.spaceGame. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var backingAudio = AVAudioPlayer()

class GameViewController: UIViewController {

    
    
     override func viewDidLoad() {
       super.viewDidLoad()
            
        if let filetPath = Bundle.main.path(forResource: "backingSound", ofType: "mp3") {
            let audioNSURL = URL(fileURLWithPath: filetPath)
            
            do { backingAudio = try AVAudioPlayer(contentsOf: audioNSURL)}
            catch { return print("Cannot find the audio")}
        }
        
        backingAudio.numberOfLoops = -1
        backingAudio.volume = 0.3
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "musicOff") {
            backingAudio.stop()
        } else {
            backingAudio.play()
        }
        
        
        if let view = self.view as! SKView? {
            let scene = LaunchScreenCustom(size: CGSize(width: 1536, height: 2048))

            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
