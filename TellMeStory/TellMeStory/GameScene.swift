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
    var mic: SKSpriteNode!
    
//    var auEngine: AVAudioEngine!
//    var inputNode: AVAudioInputNode!
//    var audioSession: AVAudioSession!
//    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    var isRecording = false
    
    let audEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "id"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override func didMove(to view: SKView) {
//        checkPermissions()
        setupMonkey()
        
        mic = (childNode(withName: "Mic") as! SKSpriteNode)
 
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
            } else if node == mic {
                print("mic touched")
                startRecognize()
            }
        }
        
    }
    
}

extension GameScene {
    
    func startRecognize() {
        
        // setup audio engine and speech recognizer
        let node = audEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // prepare and start recording
        audEngine.prepare()
        do {
            try audEngine.start()
        } catch {
            return print(error)
        }
        
        // check if the recognizer is available for device and locale
        guard let myRecognizer = SFSpeechRecognizer() else {
            // A recognizer is not supported for the current locale
            return
        }
        if !myRecognizer.isAvailable {
            // A recognizer is not available right now
            return
        }
        
        // call the recognizerTask method
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                print(bestString)
            } else if let error = error {
                print(error)
            }
        })

        
        
        
    }
    
//    // MARK: - Speech recognition
//    private func startRecording() {
//        // MARK: 1. Create a recognizer.
//
//        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "id")), recognizer.isAvailable else {
//            print("Speech recognizer not available.")
////            handleError(withMessage: "Speech recognizer not available.")
//            return
//        }
//
//        // MARK: 2. Create a speech recognition request.
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        recognitionRequest!.shouldReportPartialResults = true
//
//        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
//            guard error == nil else {
//                print("Error mark 2")
////                self.handleError(withMessage: error!.localizedDescription)
//                return
//            }
//
//            guard let result = result else { return }
//
//            let resultString = "\(result.bestTranscription.formattedString)"
//
//            print("got a new result: \(resultString), final : \(result.isFinal)")
//
////            if(resultString.lowercased().contains(self.selectedStory!.keyword1.lowercased())) {
////                self.checkKeyword1ImageView.isHidden = false
////                //                    self.pictureKeyword1ImageView.isHidden = true
////                self.keyword1View.removeFromSuperview()
////                self.keyword1View.image = UIImage(named: self.selectedStory!.keyword1)?.withRenderingMode(.alwaysOriginal)
////                self.storyImage.addSubview(self.keyword1View)
////            }
////
////            if(resultString.lowercased().contains(self.selectedStory!.keyword2.lowercased())) {
////                self.checkKeyword2ImageView.isHidden = false
////                //                   self.pictureKeyword2ImageView.isHidden = true
////                self.keyword2View.removeFromSuperview()
////                self.keyword2View.image = UIImage(named: self.selectedStory!.keyword2)?.withRenderingMode(.alwaysOriginal)
////                self.storyImage.addSubview(self.keyword2View)
////            }
////
////            if(resultString.lowercased().contains(self.selectedStory!.keyword3.lowercased())) {
////                self.checkKeyword3ImageView.isHidden = false
////                //                    self.pictureKeyword3ImageView.isHidden = true
////                self.keyword3View.removeFromSuperview()
////                self.keyword3View.image = UIImage(named: self.selectedStory!.keyword3)?.withRenderingMode(.alwaysOriginal)
////                self.storyImage.addSubview(self.keyword3View)
////
////            }
////
////            if(resultString.lowercased().contains(self.selectedStory!.keyword4.lowercased())) {
////                self.checkKeyword4ImageView.isHidden = false
////                //                    self.pictureKeyword4ImageView.isHidden = true
////                self.keyword4View.removeFromSuperview()
////                self.keyword4View.image = UIImage(named: self.selectedStory!.keyword4)?.withRenderingMode(.alwaysOriginal)
////                self.storyImage.addSubview(self.keyword4View)
////
////            }
//
//            if result.isFinal {
//                DispatchQueue.main.async {
// //                   self.updateUI(withResult: result)
//                }
//            }
//        }
//
//        // MARK: 3. Create a recording and classification pipeline.
//        // Item of Graph called Node: input node, output node, and mixer nodes
//
//        auEngine = AVAudioEngine()
//        inputNode = auEngine.inputNode
//
//        // add note to the graph
//        //bus is channel we are using
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//            self.recognitionRequest?.append(buffer)
//        }
//
//        // 3.b. AudioEngine Build Graph
//        audioEngine.prepare()
//
//        // MARK: 4. Start recognizing speech.
//        do {
//            // Activate the session.
//            audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
//            // Start the processing pipeline.
//            try audioEngine.start()
//        } catch {
//            print("Mark 4 Error")
////            handleError(withMessage: error.localizedDescription)
//        }
//
//    }
//
//    func stopRecording() {
//
//        //End the recognition request
//        recognitionRequest?.endAudio()
//        recognitionRequest = nil
//
//        //Stop recording
//        auEngine.stop()
//        inputNode.removeTap(onBus: 0) //call after audio engine is stopped as it modifies the graph
//
//        //Stop our Session
//        try? audioSession.setActive(false)
//
//
//    }
//
//    func checkPermissions() {
//        SFSpeechRecognizer.requestAuthorization { (authStatus) in
//            DispatchQueue.main.async {
//                switch authStatus {
//                case .authorized:
//                    //TODO implment.
//                    break
//                    //                case .denied:
//                    //                    //TODO implmement
//                    //                    break
//                    //                case .restricted:
//                    //                    //TODO Implmenet
//                    //                    break
//                    //                case .notDetermined:
//                    //                    // TODO: implement
//                //                    break
//                default:
//                    break
//                    //self.handlePermissioinFailed()
//
//                }
//            }
//        }
//    }
//
}
