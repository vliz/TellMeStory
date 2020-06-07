//
//  PuzzleStoryViewController.swift
//  Tell Me Story
//
//  Created by Edwin Sendjaja on 6/7/20.
//  Copyright © 2020 Edwin Sendjaja Inc. All rights reserved.
//

import UIKit
import AVFoundation //this is for Speech Synthesis (App talking)
import Speech

class PuzzleStoryViewController: UIViewController {

    @IBOutlet weak var startGuessButton: UIButton!
    
    
    @IBOutlet weak var checkKeyword1ImageView: UIImageView!
    @IBOutlet weak var checkKeyword2ImageView: UIImageView!
    @IBOutlet weak var checkKeyword3ImageView: UIImageView!
    @IBOutlet weak var checkKeyword4ImageView: UIImageView!
    
    
    @IBOutlet weak var pictureKeyword1ImageView: UIImageView!
    @IBOutlet weak var pictureKeyword2ImageView: UIImageView!
    @IBOutlet weak var pictureKeyword3ImageView: UIImageView!
    @IBOutlet weak var pictureKeyword4ImageView: UIImageView!
    
    
    @IBOutlet weak var keyword1Label: UILabel!
    @IBOutlet weak var keyword2Label: UILabel!
    @IBOutlet weak var keyword3Label: UILabel!
    @IBOutlet weak var keyword4Label: UILabel!
    
    public private(set) var isRecording = false
    
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private let userData = UserData(storyTitle: "Seekor Anjing di Taman",
                                    storyImage: "the dog and the hare",
                                    defaultStory: """
Pada suatu siang hari, Maddie berjalan-jalan di taman yang indah sekali. Banyak pohon-pohon hijau yang tinggi-tinggi di taman itu. Tiba-tiba, “GUK GUK”, datang seekor Maddie berkaki empat menghampirinya. “Guk Guk”.
Maddie senang sekali dan bermain dengan anjing yang berwarna putih itu dan ia memberi apel yang dibawanya. “Guk Guk”, si anjing happy! Namun matahari mulai terbenam, Maddie dan orang tuanya berpamitan dengan anjing itu dan pulang ke rumah.
""",
                                    keyword1: "Anjing",
                                   keyword2: "Pohon",
                                   keyword3: "Apel",
                                   keyword4: "Matahari")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkKeyword1ImageView.isHidden = true
        self.checkKeyword2ImageView.isHidden = true
        self.checkKeyword3ImageView.isHidden = true
        self.checkKeyword4ImageView.isHidden = true
        
        keyword1Label.text = userData.keyword1
        keyword2Label.text = userData.keyword2
        keyword3Label.text = userData.keyword3
        keyword4Label.text = userData.keyword4

    }
    

    @IBAction func startGuessButtonTapped(_ sender: UIButton) {
       if isRecording {
           stopRecording()
       } else {
           startRecording()
       }
       isRecording.toggle()
       
       sender.setTitle((isRecording ? "Stop" : "Start") + " Guessing The Keywords", for: .normal)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermissions()
    }
    
       // MARK: - Speech recognition
        private func startRecording() {
            // MARK: 1. Create a recognizer.
            
            guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "id")), recognizer.isAvailable else {
                handleError(withMessage: "Speech recognizer not available.")
                return
            }
            
            // MARK: 2. Create a speech recognition request.
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest!.shouldReportPartialResults = true

            recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
                guard error == nil else {
                    self.handleError(withMessage: error!.localizedDescription)
                    return
                }
                
                guard let result = result else { return }
                
                let resultString = "\(result.bestTranscription.formattedString)"

                print("got a new result: \(resultString), final : \(result.isFinal)")

                if(resultString.lowercased().contains(self.userData.keyword1.lowercased())) {
                    self.checkKeyword1ImageView.isHidden = false
                    self.pictureKeyword1ImageView.isHidden = true
                }
                
                if(resultString.lowercased().contains(self.userData.keyword2.lowercased())) {
                   self.checkKeyword2ImageView.isHidden = false
                   self.pictureKeyword2ImageView.isHidden = true
                }
                
                if(resultString.lowercased().contains(self.userData.keyword3.lowercased())) {
                    self.checkKeyword3ImageView.isHidden = false
                    self.pictureKeyword3ImageView.isHidden = true

               }
                
                if(resultString.lowercased().contains(self.userData.keyword4.lowercased())) {
                    self.checkKeyword4ImageView.isHidden = false
                    self.pictureKeyword4ImageView.isHidden = true

               }
                
                if result.isFinal {
                    DispatchQueue.main.async {
                        self.updateUI(withResult: result)
                    }
                }
            }
            
            // MARK: 3. Create a recording and classification pipeline.
            // Item of Graph called Node: input node, output node, and mixer nodes
            
            audioEngine = AVAudioEngine()
            inputNode = audioEngine.inputNode
            
            // add note to the graph
            //bus is channel we are using
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.recognitionRequest?.append(buffer)
            }
            
            // 3.b. AudioEngine Build Graph
            audioEngine.prepare()
            
            // MARK: 4. Start recognizing speech.
              do {
                     // Activate the session.
                     audioSession = AVAudioSession.sharedInstance()
                     try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
                     try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

                     // Start the processing pipeline.
                     try audioEngine.start()
                 } catch {
                     handleError(withMessage: error.localizedDescription)
                 }
            
            
        }
        
        private func updateUI(withResult result: SFSpeechRecognitionResult) {
            
            //update the UI: Present an alert
            let ac  = UIAlertController(title: "You Said",
                                        message: result.bestTranscription.formattedString,
                                        preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            
        }
        
        
        private func stopRecording() {
            
            //End the recognition request
            recognitionRequest?.endAudio()
            recognitionRequest = nil
            
            //Stop recording
            audioEngine.stop()
            inputNode.removeTap(onBus: 0) //call after audio engine is stopped as it modifies the graph
            
            //Stop our Session
            try? audioSession.setActive(false)
            
            
        }
        
        
        private func checkPermissions() {
            SFSpeechRecognizer.requestAuthorization { (authStatus) in
                DispatchQueue.main.async {
                    switch authStatus {
                    case .authorized:
                        //TODO implment.
                        break
    //                case .denied:
    //                    //TODO implmement
    //                    break
    //                case .restricted:
    //                    //TODO Implmenet
    //                    break
    //                case .notDetermined:
    //                    // TODO: implement
    //                    break
                    default: self.handlePermissioinFailed()
                        
                    }
                }
            }
        }
        
        
        private func handlePermissioinFailed() {
            
            //Present an alert asking the user to change their settings.
            let ac = UIAlertController(title: "This app muss have access to speech recognition to work", message: "Please consider updating your settings", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplication.openSettingsURLString)!
                
                UIApplication.shared.open(url)
                
            }))
            
            ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            present(ac, animated: true)
            
            //Disable the record button
            startGuessButton.isEnabled = false
            startGuessButton.setTitle("Speech Recognition not available", for: .normal)
            
            
        }
        
        private func handleError(withMessage message: String) {
            //Present an alert
            let ac = UIAlertController(title: "An error occured", message: message, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil
            ))
            
            present(ac, animated: true)
            
            //Disabled record Button
            startGuessButton.setTitle("Not available", for: .normal)
            startGuessButton.isEnabled = false
        }


}
