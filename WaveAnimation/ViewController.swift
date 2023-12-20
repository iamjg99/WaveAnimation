//
//  ViewController.swift
//  WaveAnimation
//
//  Created by Jatin on 16/12/23.
//

import UIKit
import AVFAudio

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var audioWaveIndicator: AudioWaveIndicator!
    @IBOutlet weak var previousSong: UIButton!
    @IBOutlet weak var pauseSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    
    var timer: Timer?
    var player: AVAudioPlayer?
    var currentSongIndex = 0
    var songList = ["sample_1.mp3", "sample_2.mp3", "sample_3.mp3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioPlayer()
    }

    @IBAction func playStop(_ sender: UIButton) {
        
        if let player = player {
            if player.isPlaying {
                player.pause()
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                timer = Timer.scheduledTimer(timeInterval: 1 / 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                player.play()
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }

    @objc func timerAction() {
        if player?.isPlaying == true{
            audioWaveIndicator.power = (player?.averagePower(forChannel: 0) ?? 0)
            audioWaveIndicator.setNeedsDisplay()
            player?.updateMeters()
        }else {
            timer?.invalidate()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        pauseSong.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        currentSongIndex = (currentSongIndex + 1) % songList.count
        audioWaveIndicator.reset()
        setupAudioPlayer()
        timer = Timer.scheduledTimer(timeInterval: 1 / 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        player?.play()
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        pauseSong.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        currentSongIndex = (currentSongIndex - 1 + songList.count) % songList.count
        audioWaveIndicator.reset()
        setupAudioPlayer()
        timer = Timer.scheduledTimer(timeInterval: 1 / 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        player?.play()
    }
    
    func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: songList[currentSongIndex], withExtension: nil) else {
            print("Song not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.isMeteringEnabled = true
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextButtonTapped(UIButton())
        }
    }
}
