//
//  Constants.swift
//  Pitch Perfect
//
//  Created by Mohsen Almakrami on 05/09/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import Foundation


//MARK:- Segue

public let playFilterSegue = "PlayingFilterSegue"


//MARK:

public let AudioFileName = "audioRecord.m4a"

//MARK:- ImagesName
struct ImagesName {

    static let  Record = "Record"
    static let Stop = "Stop"
    static func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        NSLog("✅ \(documentsPath)")
    }

}


