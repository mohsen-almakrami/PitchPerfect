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
        
        
        
        switch sender.tag {
        case SoundFilter.slow.rawValue:
            playAudioUnit(type: .slow)      // play slow effect
        case SoundFilter.fast.rawValue:
            playAudioUnit(type: .fast)      // play fast effect
        case SoundFilter.highPitch.rawValue:
            playAudioUnit(type: .highPitch) // play high pitch effect
        case SoundFilter.lowPitch.rawValue:
            playAudioUnit(type: .lowPitch)  // play low pitch effect
        case SoundFilter.echo.rawValue:
            playAudioUnit(type: .echo)      // play echo effect
        case SoundFilter.reverb.rawValue:
            playAudioUnit(type: .reverb)    // play reverb effect
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
        
        removeAudioFile()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Playing Methods
    
    private func playAudio() {
        
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName)
        
        
        if FileManager.default.fileExists(atPath: file.path)
        {
            do
            {
                audioPlayer = try AVAudioPlayer(contentsOf: file)
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
    
    private func isAudioPlaying() -> Bool {
        if audioPlayerNode.isPlaying {
            return true
        }
        return false
    }
    
    private func stopAudio() {
        
        if isAudioPlaying() {
            audioPlayerNode.stop()
            audioPlayerNode.reset()
            audioEngine.stop()
            audioEngine.reset()
        }
    }
  
    private func removeAudioFile() {
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName)
        if FileManager.default.fileExists(atPath: file.path){
            do {
                try FileManager.default.removeItem(at: file)
            } catch let error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK:- Sound Effects
    
    private func playAudioUnit(type:SoundFilter) {
        
        if isAudioPlaying() {
           stopAudio()
        }
        
        audioEngine.attach(audioPlayerNode)
        
        switch type {
        case .slow,.lowPitch,.highPitch,.fast:
            audioEngine.attach(audioUnitTimePitch)

            audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
            audioEngine.connect(audioUnitTimePitch, to: audioEngine.outputNode, format: nil)
            
            soundEffect(type: type, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: audioUnitTimePitch, audioUnitReverb: nil, audioUnitDistortion: nil)
            
        case .echo:
            audioEngine.attach(audioUnitDistortion)
            
            audioEngine.connect(audioPlayerNode, to: audioUnitDistortion, format: nil)
            audioEngine.connect(audioUnitDistortion, to: audioEngine.outputNode, format: nil)
            
            soundEffect(type: SoundFilter.echo, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: nil, audioUnitReverb: nil, audioUnitDistortion: audioUnitDistortion)
        
        case .reverb:
            audioEngine.attach(audioUnitReverb)
            
            audioEngine.connect(audioPlayerNode, to: audioUnitReverb, format: nil)
            audioEngine.connect(audioUnitReverb, to: audioEngine.outputNode, format: nil)
            
            soundEffect(type: SoundFilter.reverb, audioPlayerNode: audioPlayerNode, audioUnitTimePitch: nil, audioUnitReverb: audioUnitReverb, audioUnitDistortion: nil)
        }
        
        do {
            
            try audioEngine.start()
            audioPlayerNode.play()
        } catch let error {
            fatalError("Error \(error.localizedDescription)")
        }
    }
    
  
    
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
