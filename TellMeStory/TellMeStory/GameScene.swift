//
//  GameScene.swift
//  TellMeStory
//
//  Created by Edwin Sendjaja on 6/12/20.
//  Copyright © 2020 Edwin Sendjaja Inc. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import Speech

class GameScene: SKScene {
    
    var monkey: SKSpriteNode!
    var cat: SKSpriteNode!
    var dog: SKSpriteNode!
    var elephant: SKSpriteNode!
    var rabbit: SKSpriteNode!
    var banana1: SKSpriteNode!
    var banana2: SKSpriteNode!
    var banana3: SKSpriteNode!
    var trophy: SKSpriteNode!
    var playStoryButton: SKSpriteNode!
    var startGameButton: SKSpriteNode!
    var homeButton: SKSpriteNode!
    
    
    // Speech Recognition
    let audEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "id"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var lastString: String = ""
    var keyGuessed: Int = 0
    
    var emitter: CAEmitterLayer!

    // Properties for Confetti
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
    
    override func didMove(to view: SKView) {
        
        setupPlayStoryButton()
        setupBanana1()
        setupBanana2()
        setupBanana3()
    }
    
    func startStory() {
        let storySoundNode = SKAudioNode(fileNamed: "story.mp3")
        addChild(storySoundNode)
           
        self.run(SKAction.wait(forDuration: 12)) {
            self.setupCat()
            self.cat.colorBlendFactor = 0
            self.setCatAction()
        }
        
        self.run(SKAction.wait(forDuration: 26)) {
            self.setupElephant()
            self.elephant.colorBlendFactor = 0
            self.setElephantAction()
        }
        
        self.run(SKAction.wait(forDuration: 42)) {
            self.setupRabbit()
            self.rabbit.colorBlendFactor = 0
            self.setRabbitAction()
        }
        
        self.run(SKAction.wait(forDuration: 58)) {
            self.setupDog()
            self.dog.colorBlendFactor = 0
            self.setDogAction()
        }
        
        self.run(SKAction.wait(forDuration: 85)) {
            self.banana1.run(SKAction.moveTo(y: 105, duration: 1))
        }
        
        self.run(SKAction.wait(forDuration: 87)) {
            self.banana2.run(SKAction.moveTo(y: 105, duration: 1))
        }
        
        self.run(SKAction.wait(forDuration: 89)) {
            self.banana3.run(SKAction.moveTo(y: 105, duration: 1))
        }
        
        self.run(SKAction.wait(forDuration: 122)) {
            self.setupMonkey()
            self.monkey.colorBlendFactor = 0
            self.setMonkeyAction()
        }
        
        self.run(SKAction.wait(forDuration: 152)) {
            storySoundNode.removeFromParent()
            self.setupStartGameButton()
        }
        
    


    }
    
    func startGame() {
        removeAllActions()
        cat.removeFromParent()
        elephant.removeFromParent()
        dog.removeFromParent()
        monkey.removeFromParent()
        rabbit.removeFromParent()
        
        setupMonkey()
        setupCat()
        setupDog()
        setupElephant()
        setupRabbit()
        setupBanana1()
        setupBanana2()
        setupBanana3()
        checkPermissions()
        startRecognize()
        
        let backgroundSoundNode = SKAudioNode(fileNamed: "jungle.mp3")
        backgroundSoundNode.autoplayLooped = true
        addChild(backgroundSoundNode)
    }
    
    func setupPlayStoryButton() {
        playStoryButton = SKSpriteNode(imageNamed: "playStoryButton")
        playStoryButton.zPosition = 2
        playStoryButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(playStoryButton)
    }
    
    func setupStartGameButton() {
        startGameButton = SKSpriteNode(imageNamed: "startGameButton")
        startGameButton.zPosition = 2
        startGameButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(startGameButton)
    }
    
    func setupHomeButton() {
        homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.zPosition = 3
        homeButton.position = CGPoint(x: 48, y: 640)
        homeButton.anchorPoint = .zero
        addChild(homeButton)
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
    
    func setupCat() {
        cat = SKSpriteNode(imageNamed: "cat 1")
        cat.name = "cat"
        cat.scale(to: CGSize(width: 189, height: 142))
        cat.position = CGPoint(x: 340, y: 34)
        cat.anchorPoint = .zero
        cat.zPosition = 1
        cat.color = .black
        cat.colorBlendFactor = 1
        addChild(cat)
    }
    
    func setupDog() {
        dog = SKSpriteNode(imageNamed: "dog 1")
        dog.scale(to: CGSize(width: 226, height: 170))
        dog.position = CGPoint(x: 1468, y: 34)
        dog.anchorPoint = .zero
        dog.zPosition = 1
        dog.color = .black
        dog.colorBlendFactor = 1
        addChild(dog)
    }
    
    func setupElephant() {
        elephant = SKSpriteNode(imageNamed: "gajah 1")
        elephant.scale(to: CGSize(width: 378, height: 283))
        elephant.position = CGPoint(x: 582, y: 82)
        elephant.anchorPoint = .zero
        elephant.zPosition = 1
        elephant.color = .black
        elephant.colorBlendFactor = 1
        addChild(elephant)
    }
    
    func setupRabbit() {
        rabbit = SKSpriteNode(imageNamed: "rabbit 1")
        rabbit.scale(to: CGSize(width: 265, height: 198))
        rabbit.position = CGPoint(x: 1110, y: 20)
        rabbit.anchorPoint = .zero
        rabbit.zPosition = 1
        rabbit.color = .black
        rabbit.colorBlendFactor = 1
        addChild(rabbit)
    }
    
    func setupBanana1() {
        banana1 = SKSpriteNode(imageNamed: "banana")
        banana1.scale(to: CGSize(width: 92, height: 77))
        banana1.position = CGPoint(x: 1440, y: 425)
        banana1.anchorPoint = .zero
        banana1.zPosition = 1
        addChild(banana1)
    }
    
    func setupBanana2() {
        banana2 = SKSpriteNode(imageNamed: "banana")
        banana2.scale(to: CGSize(width: 92, height: 77))
        banana2.position = CGPoint(x: 1311, y: 524)
        banana2.anchorPoint = .zero
        banana2.zPosition = 1
        addChild(banana2)
    }
    
    func setupBanana3() {
        banana3 = SKSpriteNode(imageNamed: "banana")
        banana3.scale(to: CGSize(width: 92, height: 77))
        banana3.position = CGPoint(x: 1050, y: 480)
        banana3.anchorPoint = .zero
        banana3.zPosition = 1
        addChild(banana3)
    }
    
    func setMonkeyAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "Monkey \(i)"))
        }
        for i in (2...4).reversed() {
            textures.append(SKTexture(imageNamed: "Monkey \(i)"))
        }
        
        let monkeyAnimate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        let monkeySound = SKAction.playSoundFileNamed("monkeysound", waitForCompletion: false)
        monkey.run(SKAction.group([monkeyAnimate, monkeySound]))
    }
    
    func setCatAction() {
        var textures = [SKTexture]()
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "cat \(i)"))
        }
        for i in (2...5).reversed() {
            textures.append(SKTexture(imageNamed: "cat \(i)"))
        }
        
        let catAnimate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        let catSound = SKAction.playSoundFileNamed("catsound", waitForCompletion: false)
        cat.run(SKAction.group([catAnimate, catSound]))
        
    }
    
    func setDogAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "dog \(i)"))
        }
        for i in (2...4).reversed() {
            textures.append(SKTexture(imageNamed: "dog \(i)"))
        }
        
        let dogAnimate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        let dogSound = SKAction.playSoundFileNamed("dogsound", waitForCompletion: false)
        dog.run(SKAction.group([dogAnimate, dogSound]))
    }
    
    func setElephantAction() {
        var textures = [SKTexture]()
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "gajah \(i)"))
        }
        for i in (2...5).reversed() {
            textures.append(SKTexture(imageNamed: "gajah \(i)"))
        }
        
        let elephantAnimate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        let elephantSound = SKAction.playSoundFileNamed("elephantsound", waitForCompletion: false)
        elephant.run(SKAction.group([elephantAnimate, elephantSound]))
    }
    
    func setRabbitAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "rabbit \(i)"))
        }
        for i in (2...4).reversed() {
            textures.append(SKTexture(imageNamed: "rabbit \(i)"))
        }
        
        let rabbitAnimate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        let rabbitSound = SKAction.playSoundFileNamed("rabbitsound", waitForCompletion: false)
        rabbit.run(SKAction.group([rabbitAnimate, rabbitSound]))
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            switch node {
            case monkey:
                setMonkeyAction()
            case cat:
                setCatAction()
            case dog:
                setDogAction()
            case elephant:
                setElephantAction()
            case rabbit:
                setRabbitAction()
            case playStoryButton:
                startStory()
                playStoryButton.removeFromParent()
            case startGameButton:
                startGameButton.removeFromParent()
                startGame()
            case homeButton:
                removeAllChildren()
                let scene = SKScene(fileNamed: "MainMenuScene")
                scene?.scaleMode = scaleMode                
                view?.presentScene(scene)
                emitter.removeFromSuperlayer()
            default:
                break
            }
        }
    }
    
    func gameFinish() {
        createConfetti()
        
        trophy = SKSpriteNode(imageNamed: "trophy")
        trophy.scale(to: CGSize(width: 466, height: 723))
        trophy.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        trophy.zPosition = 2
        addChild(trophy)
        
        setupHomeButton()
 
    }
}

// for Speech Recognition
extension GameScene {
    
    func startRecognize() {
        
        // 1. Setup audio engine and speech recognizer
        let node = audEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // 2. Prepare and start recording
        audEngine.prepare()
        do {
            try audEngine.start()
        } catch {
            return print(error)
        }
        
        // 3. Check if the recognizer is available for device and locale
        guard let myRecognizer = SFSpeechRecognizer() else {
            // A recognizer is not supported for the current locale
            return
        }
        if !myRecognizer.isAvailable {
            // A recognizer is not available right now
            return
        }
        request.shouldReportPartialResults = true
        
        // 4. Call the recognizerTask method and get the said words
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString

                // Get last said word
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    self.lastString = String(bestString[indexTo...])
                }
//                print(self.lastString.lowercased())
                self.checkForKeywordSaid(resultString: self.lastString.lowercased())
                
                if self.keyGuessed == 5 {
                    self.gameFinish()
                }
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func checkForKeywordSaid(resultString: String) {
        switch resultString {
        case "monyet":
            monkey.colorBlendFactor = 0
            keyGuessed += 1
        case "kucing":
            cat.colorBlendFactor = 0
            keyGuessed += 1
        case "anjing":
            dog.colorBlendFactor = 0
            keyGuessed += 1
        case "gajah":
            elephant.colorBlendFactor = 0
            keyGuessed += 1
        case "kelinci":
            rabbit.colorBlendFactor = 0
            keyGuessed += 1
        default:
            break
        }
    }
    
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
//                case .denied:
                    // show alert?
                default:
                    break
                }
            }
        }
    }

}

//enum Colors {
//
//    static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
//    static let blue = UIColor.blue
//    static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
//    static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
//}
//
//enum Images {
//
//    static let box = UIImage(named: "Box")!
//    static let triangle = UIImage(named: "Triangle")!
//    static let circle = UIImage(named: "Circle")!
//}

// For Confetti
extension GameScene {
    
    fileprivate func createConfetti() {

        emitter = CAEmitterLayer()
        emitter.name = "confettiLayer"
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

