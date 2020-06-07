//
//  ViewController.swift
//  Tell Me Story
//
//  Created by Edwin Sendjaja on 6/7/20.
//  Copyright © 2020 Edwin Sendjaja Inc. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    
    @IBOutlet weak var storyImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyword1Label: UILabel!
    @IBOutlet weak var keyword2Label: UILabel!
    @IBOutlet weak var keyword3Label: UILabel!
    @IBOutlet weak var keyword4Label: UILabel!
    
    @IBOutlet weak var defaultStoryTextView: UITextView!
    
    @IBOutlet weak var userStoryTextView: UITextView!
    
    @IBOutlet weak var storyTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var playDefaultStoryButton: UIButton!
    @IBOutlet weak var stopDefaultStoryButton: UIButton!
    
    @IBOutlet weak var recordUserStoryButton: UIButton!
    
    @IBOutlet weak var playbackUserStoryButton: UIButton!
    
    @IBOutlet weak var userStoryButtonsView: UIView!
    
    private var defaultStoryIsPlaying: Bool = false
    private let synthesizer = AVSpeechSynthesizer()

    
    @IBOutlet weak var nextToPuzzleButton: UIButton!
    
    
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
        
        synthesizer.delegate = self
        
        defaultStoryTextView.isHidden = false
        userStoryTextView.isHidden = true
        playDefaultStoryButton.isHidden = false
        stopDefaultStoryButton.isHidden = true
        userStoryButtonsView.isHidden = true
        
        storyImage.image = UIImage(named: userData.storyImage)
        titleLabel.text = userData.storyTitle
        defaultStoryTextView.text = userData.defaultStory
        keyword1Label.text = userData.keyword1
        keyword2Label.text = userData.keyword2
        keyword3Label.text = userData.keyword3
        keyword4Label.text = userData.keyword4

    }

    @IBAction func storyTypeSegmentedIndexChanged(_ sender: UISegmentedControl) {
        switch storyTypeSegmentedControl.selectedSegmentIndex {
         case 0:
            defaultStoryTextView.isHidden = false
            userStoryTextView.isHidden = true
            
            if(defaultStoryIsPlaying){
                playDefaultStoryButton.isHidden = false
            } else {
                stopDefaultStoryButton.isHidden = true
            }
            
            userStoryButtonsView.isHidden = true
         case 1:
            defaultStoryTextView.isHidden = true
            userStoryTextView.isHidden = false
            
            if(defaultStoryIsPlaying){
                playDefaultStoryButton.isHidden = true
            } else {
                stopDefaultStoryButton.isHidden = false
            }
            
            stopDefaultStoryButton.isHidden = false
            userStoryButtonsView.isHidden = false
        default:
             break
         }
    }
    
    
    @IBAction func playDefaultStory(_ sender: UIButton) {
        if(defaultStoryIsPlaying) {
            stopDefaultStoryTelling()

        } else {
            playDefaultStoryTelling()
        }
        
        defaultStoryIsPlaying.toggle()
        changeDefaultStoryPlayButton()
    }
    
    private func playDefaultStoryTelling() {
        let utterance = AVSpeechUtterance(string: userData.defaultStory)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.2

        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Damayanti-compact")

        synthesizer.speak(utterance)
        //synthesizer.stopSpeaking(at: .immediate)
    }
    
    private func stopDefaultStoryTelling() {
        let utterance = AVSpeechUtterance(string: userData.defaultStory)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.2

        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Damayanti-compact")

        //synthesizer.speak(utterance)
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    private func changeDefaultStoryPlayButton() {
        if(defaultStoryIsPlaying){
            playDefaultStoryButton.isHidden = true
            stopDefaultStoryButton.isHidden = false
        } else {
            playDefaultStoryButton.isHidden = false
            stopDefaultStoryButton.isHidden = true
        }
        
    }
    
}

extension ViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        defaultStoryIsPlaying.toggle()
        changeDefaultStoryPlayButton()
    }
}

