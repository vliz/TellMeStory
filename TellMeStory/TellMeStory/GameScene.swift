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
    var trophy: SKSpriteNode!
    
    var mic: SKSpriteNode!
    
    // Speech Recognition
    let audEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "id"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var lastString: String = ""
    var keyGuessed: Int = 0
    
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
        checkPermissions()
        setupMonkey()
        setupCat()
        setupDog()
        setupElephant()
        setupRabbit()
        
        mic = (childNode(withName: "Mic") as! SKSpriteNode)
        
        // test background music
//        let backgroundSoundNode = SKAudioNode(fileNamed: "jungle.mp3")
//        backgroundSoundNode.autoplayLooped = true
//        addChild(backgroundSoundNode)
 
    }
    
    func setupMonkey() {
        monkey = SKSpriteNode(imageNamed: "Monkey 1")
        monkey.name = "monyet"
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
        cat.scale(to: CGSize(width: 189, height: 142))
        cat.position = CGPoint(x: 320, y: 34)
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
        elephant = SKSpriteNode(imageNamed: "elephant 1")
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
        rabbit.position = CGPoint(x: 1015, y: 30)
        rabbit.anchorPoint = .zero
        rabbit.zPosition = 1
        rabbit.color = .black
        rabbit.colorBlendFactor = 1
        addChild(rabbit)
    }
    
    func setMonkeyAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "Monkey \(i)"))
        }
        for i in (2...4).reversed() {
            textures.append(SKTexture(imageNamed: "Monkey \(i)"))
        }
        
        
        let monkeyAnimate = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false)
        let monkeySound = SKAction.playSoundFileNamed("monkeysound", waitForCompletion: false)
        monkey.run(SKAction.group([monkeyAnimate, monkeySound]))
    }
    
    func setCatAction() {
        var textures = [SKTexture]()
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "cat \(i)"))
        }
        
        let catAnimate = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false)
        let catSound = SKAction.playSoundFileNamed("catsound", waitForCompletion: false)
        cat.run(SKAction.group([catAnimate, catSound]))
    }
    
    func setDogAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "dog \(i)"))
        }
        
        let dogAnimate = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false)
        let dogSound = SKAction.playSoundFileNamed("dogsound", waitForCompletion: false)
        dog.run(SKAction.group([dogAnimate, dogSound]))
    }
    
    func setElephantAction() {
        var textures = [SKTexture]()
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "elephant \(i)"))
        }
        
        let elephantAnimate = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false)
        let elephantSound = SKAction.playSoundFileNamed("elephantsound", waitForCompletion: false)
        elephant.run(SKAction.group([elephantAnimate, elephantSound]))
    }
    
    func setRabbitAction() {
        var textures = [SKTexture]()
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "rabbit \(i)"))
        }
        
        rabbit.run(SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: false))
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
            case mic:
                startRecognize()
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

