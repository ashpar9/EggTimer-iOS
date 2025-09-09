//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let eggTimes = ["Soft": 300,
                    "Medium": 420,
                    "Hard": 720]
    
    var timer: Timer?
    var player: AVAudioPlayer?
    
    var totalTime = 0
    var secondsPassed = 0
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        // 1. Stop any old timer
        timer?.invalidate()
        
        // 2. Reset state
        guard let hardness = sender.currentTitle,
              let time = eggTimes[hardness] else { return }
        totalTime = time
        secondsPassed = 0
        
        progressBar.progress = 0
        titleLabel.text = hardness
        
        // 3. Schedule and store the timer
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
        } else {
            // 4. Invalidate the running timer
            timer?.invalidate()
            titleLabel.text = "DONE!"
            
            // 5. Play your alarm sound once
            guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            else { return }
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Failed to load sound: \(error)")
            }
        }
    }
}
