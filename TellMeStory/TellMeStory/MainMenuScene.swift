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
    let closeButton = SKSpriteNode(imageNamed: "closeButton")
    let backgroundSoundNode = SKAudioNode(fileNamed: "jingle1.mp3")
    let popUpBackgroundNode = SKSpriteNode(imageNamed: "popUpBackground")
    let titleParentGuideLabel =  SKLabelNode()
    let contentParentGuideLabel =  SKLabelNode()
    
    var birdDirection: CGFloat = 0.0
    
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
    
    var bird: SKSpriteNode!
    var birdFlyingAction: SKAction!
    
    override func didMove(to view: SKView) {
        createStartButton()
        createParentsGuideButton()
        setupBackgroundMusic()
        
        setupBirdFlyingAction()
        setupBird()


//        createConfetti()
    }


    override func update(_ currentTime: TimeInterval) {

        let newPosition = bird.position.x + (birdDirection * 3)
        if newPosition >= -500 && newPosition <= 2500 {
            if newPosition == -500 {
                birdDirection = 1
                bird.xScale = 0.1

            } else if newPosition == 2500 {
                birdDirection = -1
                bird.xScale = -0.1
            }
        }
        
        bird.position.x = newPosition

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
     
        if startButton.frame.contains(touch.location(in: self)) {
            goToGameScene()
        }
        
        if parentGuideButton.frame.contains(touch.location(in: self)) {
            openParentsGuide()
        }
        
        if closeButton.frame.contains(touch.location(in: self)) {
            closeParentsGuide()
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
    
    fileprivate func setupPopUpBackground() {
        
        popUpBackgroundNode.name = "popUpBackground"
        popUpBackgroundNode.size.height = 653.36
        popUpBackgroundNode.size.width = 1000
        popUpBackgroundNode.position = CGPoint(x: self.size.width / 2 + 9, y: self.size.height / 2 + 71)
        //popUpBackgroundNode.anchorPoint = .zero
        popUpBackgroundNode.zPosition = 5
        popUpBackgroundNode.color = .black
        addChild(popUpBackgroundNode)
        setupParentGuideText()
        setupCloseButton()
    }
    
    
    fileprivate func setupContentParentsGuide() {
        
        let guideText = """
        1. Mohon mendampingi anak selama applikasi terbuka.

        2. Pencet tombol mulai untuk memulai bacaan.

        3. Tebak Gambar: Untuk membuka gambar objek, anak diharapkan menyebut objek tersebut.

        4. Jika objek tersebut terbuka semua, target tebak gambar telah tercapai.

        """
        contentParentGuideLabel.text = guideText
        contentParentGuideLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 90)
        contentParentGuideLabel.fontColor = UIColor(red: 0.133, green: 0.596, blue: 0.057, alpha: 1)
        contentParentGuideLabel.numberOfLines = 0
        contentParentGuideLabel.zPosition = 6
        contentParentGuideLabel.fontName = "Helvetica"
        contentParentGuideLabel.fontSize = 29
        contentParentGuideLabel.preferredMaxLayoutWidth =  830
        addChild(contentParentGuideLabel)
    }
    
    fileprivate func setupTitleParentsGuide() {
        
        let attributedString = NSMutableAttributedString.init(string: "Petunjuk")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: 1,
                                      range: NSRange.init(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont(name: "Helvetica-Bold", size: 36),
                                      range: NSRange.init(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor(red: 0.133, green: 0.596, blue: 0.057, alpha: 1),
                                      range:  NSRange.init(location: 0, length: attributedString.length))
        
        titleParentGuideLabel.attributedText = attributedString
        titleParentGuideLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 250)
        titleParentGuideLabel.zPosition = 6
        
        addChild(titleParentGuideLabel)
    }
    
    fileprivate func setupParentGuideText() {
        setupTitleParentsGuide()
        setupContentParentsGuide()
    }
    
    fileprivate func setupCloseButton() {
        closeButton.name = "closeButton"
        closeButton.size.height = 150
        closeButton.size.width = 310
        
        closeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 305)
        addChild(closeButton)
    }
    
    fileprivate func closeParentsGuide() {
        closeButton.removeFromParent()
        titleParentGuideLabel.removeFromParent()
        contentParentGuideLabel.removeFromParent()
        popUpBackgroundNode.removeFromParent()
        
        createStartButton()
        createParentsGuideButton()
    }

    fileprivate func setupBackgroundMusic() {
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
        startButton.removeFromParent()
        parentGuideButton.removeFromParent()
        setupPopUpBackground()
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
    
    
    fileprivate func setupBird() {

        bird = SKSpriteNode(imageNamed: "Bird 1")
        bird.name = "bird"

        bird.position = CGPoint(x: 100, y: 700)
        bird.anchorPoint = .zero
        bird.zPosition = 1
        bird.xScale = 0.1
        bird.yScale = 0.1
        birdDirection = 1
        
        addChild(bird)
        bird.run(birdFlyingAction, withKey: "flyingAnimation")
        
    }
    
    fileprivate func setupBirdFlyingAction() {

        var textures = [SKTexture]()
        for i in 1...2 {
            textures.append(SKTexture(imageNamed: "Bird \(i)"))
        }
        birdFlyingAction = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
        
    }
    
}
