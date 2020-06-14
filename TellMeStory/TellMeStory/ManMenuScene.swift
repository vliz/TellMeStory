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
    
    // Propertoes for Confetti: START //
    var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    
    var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
    ]
    
    var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    // Propertoes for Confetti: END //

    override func didMove(to view: SKView) {
        createStartButton()
        createParentsGuideButton()
        setupBackgroundMusic()
//        createConfetti()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
     
        if startButton.frame.contains(touch.location(in: self)) {
            goToGameScene()
        }
        
        if parentGuideButton.frame.contains(touch.location(in: self)) {
            openParentsGuide()
        }
    
    }
    
    fileprivate func createStartButton() {
        startButton.name = "startButton"
        startButton.size.height = 150
        startButton.size.width = 150
        
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 150)
        addChild(startButton)
    }
    
    fileprivate func createParentsGuideButton() {
        parentGuideButton.name = "parentGuideButton"
        parentGuideButton.size.height = 150
        parentGuideButton.size.width = 310
        
        parentGuideButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 50)
        addChild(parentGuideButton)
    }
    
    fileprivate func setupBackgroundMusic() {
        // 2. create node to play sound effect and action to modify the volume
        
        backgroundSoundNode.autoplayLooped = true
        self.addChild(backgroundSoundNode)
    }
    
    fileprivate func goToGameScene() {
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene?.scaleMode = scaleMode
        
        let gameTransition = SKTransition.fade(withDuration: 0.3)
        
        view?.presentScene(gameScene!, transition: gameTransition)
        
    }
    
    fileprivate func openParentsGuide() {
        print("asldkfj")
    }

}

enum Colors {
    
    static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
    static let blue = UIColor.blue
    static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
    static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
}

enum Images {
    
    static let box = UIImage(named: "Box")!
    static let triangle = UIImage(named: "Triangle")!
    static let circle = UIImage(named: "Circle")!
}

extension MainMenuScene {
    
    fileprivate func createConfetti() {

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.view!.frame.size.width / 2, y: -10)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: self.view!.frame.size.width, height: 2.0)
        emitter.emitterCells = generateEmitterCells()
        self.view!.layer.addSublayer(emitter)
    }
    
    fileprivate func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            cells.append(cell)
        }
            
        return cells
    }
    
    fileprivate func getRandomVelocity() -> Int {
         return velocities[getRandomNumber()]
     }
     
     fileprivate func getRandomNumber() -> Int {
         return Int(arc4random_uniform(4))
     }
     
     fileprivate func getNextColor(i:Int) -> CGColor {
         if i <= 4 {
             return colors[0].cgColor
         } else if i <= 8 {
             return colors[1].cgColor
         } else if i <= 12 {
             return colors[2].cgColor
         } else {
             return colors[3].cgColor
         }
     }
     
     fileprivate func getNextImage(i:Int) -> CGImage {
         return images[i % 3].cgImage!
     }
}
