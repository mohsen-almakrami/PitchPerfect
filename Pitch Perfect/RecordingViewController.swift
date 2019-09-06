//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Mohsen Almakrami on 04/09/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {

    
    //MARK:- Varibles
    
    private var isRecording = false
    private var audioRecorder : AVAudioRecorder!
    private var recordingSession : AVAudioSession!
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var startAndStopLabelOutlet: UILabel!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       recordingSession = AVAudioSession.sharedInstance()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:- IBActions
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            isRecording.toggle()
            sender.setImage(UIImage(named: ImagesName.Stop), for: .normal)
            
            if audioRecorder == nil {
                
                switch recordingSession.recordPermission {
                case .granted:
                    self.startRecording()
                case .denied:
                    self.deniedRecordPermission()
                    if isRecording{
                        isRecording.toggle()
                        sender.setImage(UIImage(named: ImagesName.Record), for: .normal)
                    }
                case .undetermined:
                    recordingSession.requestRecordPermission { [unowned self] allowed in
                        if allowed {
                            self.startRecording()
                        } else {
                            self.deniedRecordPermission()
                        }
                    }
                    
                @unknown default:
                    fatalError("record permission error")
                }
            } else {fatalError("audioRecorder is not nil")}
            
        } else {
            isRecording.toggle()
            sender.setImage(UIImage(named: ImagesName.Record), for: .normal)
            finishRecording(success: true)

        }
    }
    
    //MARK:- Recording Methods
    
    private func startRecording() {
        let audioFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AudioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
        
        do {
            
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            guard let audioRecorder = audioRecorder else {
                self.finishRecording(success: false)
                return
            }
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
                audioRecorder.record()
  
        } catch let error {
            finishRecording(success: false)
            fatalError("Recorder is catch error \(error.localizedDescription)")
        }
    }
    
    private func deniedRecordPermission() {
        let alert = UIAlertController(title: "Error", message: "You have to grante access to the microphone from Settings", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if !success {
            isRecording.toggle()
            recordButtonOutlet.setImage(UIImage(named: ImagesName.Record), for: .normal)
            
        } else {
            performSegue(withIdentifier: playFilterSegue, sender: nil)
        }
    }
}

extension RecordingViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishRecording(success: false)
        }
        
        
        print("Recorder \(flag)")
    }
    
    
}
