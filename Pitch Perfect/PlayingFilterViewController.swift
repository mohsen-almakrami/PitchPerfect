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
    
    //MARK:- IBOutlets
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAudio()
        // Do any additional setup after loading the view.
    }
    

    //MARK:- IBActions

    @IBAction func soundFilterButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case SoundFilter.slow.rawValue:
            print("Slow")
        case SoundFilter.fast.rawValue:
            print("fast")
        case SoundFilter.highPitch.rawValue:
            print("highPitch")
        case SoundFilter.lowPitch.rawValue:
            print("lowPitch")
        case SoundFilter.echo.rawValue:
            print("echo")
        case SoundFilter.reverb.rawValue:
            print("reverb")
        default:
            fatalError("Wrong tag Number for button")
        }
        
        
    }
    
    @IBAction func puaseButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func recordANewSoundButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Helps Methods
    
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
}

extension PlayingFilterViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Player \(flag)")
    }
}
