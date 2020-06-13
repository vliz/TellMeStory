//
//  ManMenuScene.swift
//  TellMeStory
//
//  Created by Edwin Sendjaja on 6/14/20.
//  Copyright © 2020 Edwin Sendjaja Inc. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    let startButton = SKSpriteNode(imageNamed: "rightButton")
    let parentGuideButton = SKSpriteNode(imageNamed: "parentGuideButton")
    let backgroundSoundNode = SKAudioNode(fileNamed: "jungle.mp3")
    
    override func didMove(to view: SKView) {
        startButton.name = "startButton"
        startButton.size.height = 150
        startButton.size.width = 150
        
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 150)
        addChild(startButton)
        
        parentGuideButton.name = "parentGuideButton"
        parentGuideButton.size.height = 150
        parentGuideButton.size.width = 310
       
        parentGuideButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 50)
        addChild(parentGuideButton)
        
        
        // 2. create node to play sound effect and action to modify the volume
        
        backgroundSoundNode.autoplayLooped = true
        self.addChild(backgroundSoundNode)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        //let startButtonNode = childNode(withName: "startButton")
        
        if startButton.frame.contains(touch.location(in: self)) {
            let gameScene = SKScene(fileNamed: "GameScene")
            gameScene?.scaleMode = scaleMode
            
            let gameTransition = SKTransition.fade(withDuration: 0.3)
            
            view?.presentScene(gameScene!, transition: gameTransition)
            
        }
        
        if parentGuideButton.frame.contains(touch.location(in: self)) {
   
            print("asldkfj")
            
            
        }
    
    }
    
    
    
}
