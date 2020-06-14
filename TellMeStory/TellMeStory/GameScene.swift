//
//  GameScene.swift
//  TellMeStory
//
//  Created by Edwin Sendjaja on 6/12/20.
//  Copyright © 2020 Edwin Sendjaja Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var monkey: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupMonkey()
 
    }
    
    func setupMonkey() {
        monkey = SKSpriteNode(imageNamed: "Monkey 1")
        monkey.scale(to: CGSize(width: 226, height: 170))
        monkey.position = CGPoint(x: 1160, y: 250)
        monkey.anchorPoint = .zero
        monkey.zPosition = 1
        monkey.color = .black
        monkey.colorBlendFactor = 1
        addChild(monkey)
    
    }
    
    func setMonkeyAction() {
        var textures = [SKTexture]()
        for i in 1...9 {
            textures.append(SKTexture(imageNamed: "Monkey \(i)"))
        }
        
        let monkeyAnimate = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false)
        
        let monkeySound = SKAction.playSoundFileNamed("monkeysound", waitForCompletion: false)

        monkey.run(SKAction.group([monkeyAnimate, monkeySound]))
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == monkey {
                print("monkey touched")
                setMonkeyAction()
            }
        }
        
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
