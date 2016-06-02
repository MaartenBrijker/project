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
    
    var player1: AKAudioPlayer?
    var player2: AKAudioPlayer?
    var player3: AKAudioPlayer?
    var player4: AKAudioPlayer?
    var player5: AKAudioPlayer?
    var mixer = AKMixer()
    
// MARK: - Setting up the database.
    
    static let sharedInstance = AudioManager()
    
    private init() { }
    
    func setUpMixerChannels(sounds: Array<String>?) {
        
        let fullNameArr1 = sounds![0].componentsSeparatedByString(".")
        let title1: String = fullNameArr1[0]
        let type1: String = fullNameArr1[1]
        let file1 = NSBundle.mainBundle().pathForResource(title1, ofType: type1)
        
        let fullNameArr2 = sounds![1].componentsSeparatedByString(".")
        let title2: String = fullNameArr2[0]
        let type2: String = fullNameArr2[1]
        let file2 = NSBundle.mainBundle().pathForResource(title2, ofType: type2)

        let fullNameArr3 = sounds![2].componentsSeparatedByString(".")
        let title3: String = fullNameArr3[0]
        let type3: String = fullNameArr3[1]
        let file3 = NSBundle.mainBundle().pathForResource(title3, ofType: type3)

        let fullNameArr4 = sounds![3].componentsSeparatedByString(".")
        let title4: String = fullNameArr4[0]
        let type4: String = fullNameArr4[1]
        let file4 = NSBundle.mainBundle().pathForResource(title4, ofType: type4)

        let fullNameArr5 = sounds![4].componentsSeparatedByString(".")
        let title5: String = fullNameArr5[0]
        let type5: String = fullNameArr5[1]
        let file5 = NSBundle.mainBundle().pathForResource(title5, ofType: type5)
        
        player1 = AKAudioPlayer(file1!)
        player2 = AKAudioPlayer(file2!)
        player3 = AKAudioPlayer(file3!)
        player4 = AKAudioPlayer(file4!)
        player5 = AKAudioPlayer(file5!)
        
        mixer.connect(player1!)
        mixer.connect(player2!)
        mixer.connect(player3!)
        mixer.connect(player4!)
        mixer.connect(player5!)
        
        AudioKit.output = mixer
        AudioKit.start()
    }

    func playAudio(name: String) {
        
        print("playing right nowwww: ", name)
        
        if name == "isinkcomb.wav" {
            if player1!.isStarted {
                player1?.stop()
            } else {
                player1?.start()
            }
        }
        if name == "isinkvoices.wav" {
            if player2!.isStarted {
                player2?.stop()
            } else {
                player2?.start()
            }
        }
        if name == "kialabells.wav" {
            if player3!.isStarted {
                player3?.stop()
            } else {
                player3?.start()
            }
        }
        if name == "NASA.wav" {
            if player4!.isStarted {
                player4?.stop()
            } else {
                player4?.start()
            }
        }
        if name == "TonalBell.aiff" {
            if player5!.isStarted {
                player5?.stop()
            } else {
                player5?.start()
            }
        }
    }
    
}