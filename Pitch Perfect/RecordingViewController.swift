//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Mohsen Almakrami on 04/09/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {

    
    //MARK:- Varibles
    
    private var isRecording = false
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var startAndStopLabelOutlet: UILabel!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:- IBActions
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
    
        if !isRecording {
            isRecording.toggle()
            sender.setImage(UIImage(named: ImagesName.Stop), for: .normal)
            
        } else {
            isRecording.toggle()
            sender.setImage(UIImage(named: ImagesName.Record), for: .normal)
            
            performSegue(withIdentifier: playFilterSegue, sender: nil)
        }
    }
    
    
    
    //MARK:- Helps Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == playFilterSegue {
            
        }
    }
    
    


}

