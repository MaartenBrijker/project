//
//  AudioManager.swift
//  project
//
//  Created by Maarten Brijker on 02/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import Foundation
import SQLite
import AudioKit

class AudioManager {
   
// MARK: - initializing the audio processors.
    
    var player: AKAudioPlayer?
    var mixer = AKMixer()
    
    
// MARK: - Setting up the database.
    
    static let sharedInstance = AudioManager()
    
    private init() { }

    func playAudio(name: String) {
        
        print("playing right nowwww: ", name)
        
        let fullNameArr = name.componentsSeparatedByString(".")
        
        let title: String = fullNameArr[0]
        let type: String = fullNameArr[1]
        
        let file = NSBundle.mainBundle().pathForResource(title, ofType: type)
        
        player = AKAudioPlayer(file!)
        
        mixer.connect(player!)
        
        AudioKit.output = mixer
        AudioKit.start()

        player?.start()
    }
    
}