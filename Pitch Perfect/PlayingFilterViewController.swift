//
//  PlayingFilterViewController.swift
//  Pitch Perfect
//
//  Created by Mohsen Almakrami on 05/09/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit
import AVFoundation

enum SoundFilter: Int {
    case slow = 1,fast,highPitch,lowPitch,echo,reverb
}

class PlayingFilterViewController: UIViewController {

    
    //MARK:- Varibles
    private var isPlaying = false
    private var audioPlayer : AVAudioPlayer!
    

    
    private let audioEngine = AVAudioEngine()
    private let audioPlayerNode = AVAudioPlayerNode()
    private let audioUnitTimePitch = AVAudioUnitTimePitch()
    private let audioUnitReverb = AVAudioUnitReverb()
    private let audioUnitDistortion = AVAudioUnitDistortion()
    
    //MARK:- IBOutlets
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    //MARK:- IBActions

    @IBAction func soundFilterButtonPressed(_ sender: UIButton) {
        
        if audioPlayerNode.isPlaying {
            return
        }
        
        switch sender.tag {
        case SoundFilter.slow.rawValue:
            print("Slow")
            playAudioUnitTimePitch(type: .slow)
        case SoundFilter.fast.rawValue:
            print("fast")
            playAudioUnitTimePitch(type: .fast)
        case SoundFilter.highPitch.rawValue:
            print("highPitch")
            playAudioUnitTimePitch(type: .highPitch)
        case SoundFilter.lowPitch.rawValue:
            print("lowPitch")
            playAudioUnitTimePitch(type: .lowPitch)
        case SoundFilter.echo.rawValue:
            print("echo")
            playAudioUnitDistortion()
        case SoundFilter.reverb.rawValue:
            print("reverb")
            playAudioUnitReverb()
        default:
            fatalError("Wrong tag Number for button")
        }
        
        
    }
    
    @IBAction func puaseButtonPressed(_ sender: UIButton) {
        
        if audioPlayerNode.isPlaying {
            audioPlayerNode.pause()
        } else {
            audioPlayerNode.play()
        }

    }
    
    
    
    @IBAction func recordANewSoundButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Playing Methods
    
    private func playAudio() {
        
        if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName).path)
        {
            do
            {
                audioPlayer = try AVAudioPlayer(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName))
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            catch let error{
                print("Error \(error.localizedDescription)")
            }
            
            
        } else {
            fatalError("No file is found")
        }
    }
    
    
    //MARK:- AudioUnitReverb
    
    private func playAudioUnitReverb() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(audioUnitReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitReverb, format: nil)
        audioEngine.connect(audioUnitReverb, to: audioEngine.outputNode, format: nil)
        
        do {
            
            try audioEngine.start()
            audioPlayerNode.play()
            soundEffect(type: SoundFilter.reverb, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: nil, audioUnitReverb: audioUnitReverb, audioUnitDistortion: nil)
        } catch let error {
            fatalError("Error \(error.localizedDescription)")
        }
        
    }
    
    //MARK:- AudioUnitDistortion
    private func playAudioUnitDistortion() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(audioUnitDistortion)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitDistortion, format: nil)
        audioEngine.connect(audioUnitDistortion, to: audioEngine.outputNode, format: nil)
        
        do {
            
            try audioEngine.start()
            audioPlayerNode.play()
            soundEffect(type: SoundFilter.echo, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: nil, audioUnitReverb: nil, audioUnitDistortion: audioUnitDistortion)
        } catch let error {
            fatalError("Error \(error.localizedDescription)")
        }
        
    }
    
    
    //MARK:- AudioUnitTimePitch
    private func playAudioUnitTimePitch(type:SoundFilter) {
        
        

        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(audioUnitTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
        audioEngine.connect(audioUnitTimePitch, to: audioEngine.outputNode, format: nil)
        
        do {
            
            try audioEngine.start()
            audioPlayerNode.play()
            soundEffect(type: type, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: audioUnitTimePitch, audioUnitReverb: nil, audioUnitDistortion: nil)
        } catch let error {
        fatalError("Error \(error.localizedDescription)")
        }
    }
    
    //MARK:- Sound Effects
    
    private func soundEffect(type: SoundFilter,audioPlayerNode:AVAudioPlayerNode, audioUnitTimePitch: AVAudioUnitTimePitch?, audioUnitReverb: AVAudioUnitReverb?,audioUnitDistortion : AVAudioUnitDistortion?) {
        let file = try! AVAudioFile(forReading: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName))
        switch type {
        case .slow :
            audioUnitTimePitch?.rate = 0.5
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        case .fast:
            audioUnitTimePitch?.rate = 2
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        case .highPitch:
            audioUnitTimePitch?.pitch = 1000
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        case .lowPitch:
            audioUnitTimePitch?.pitch = -1000
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        case .echo:
            audioUnitDistortion?.loadFactoryPreset(.multiEcho2)
            audioUnitDistortion?.wetDryMix = 30
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        case .reverb:
            audioUnitReverb?.loadFactoryPreset(.largeHall)
            audioUnitReverb?.wetDryMix = 40
            audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        }
    
 
    
    }
}


extension PlayingFilterViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Player \(flag)")
    }
}
