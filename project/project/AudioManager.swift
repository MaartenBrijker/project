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
import AVFoundation

class AudioManager {
   
// MARK: - initializing the audio processors.
    
    var player: AKAudioPlayer?
    var pitcher: AKTimePitch?
    var filter: AKToneFilter?
    var reverb: AKReverb?
    var mixer = AKMixer()
    
// MARK: - Setting up the database.
    
    static let sharedInstance = AudioManager()
    
    private init() { }
    
    var soundlink: [String: Array<AKNode>] = [:]
    
    
    // rec rec ay ay
    var recording = false
//    var recorderAV: AVAudioRecorder?
//    var audioFile: AVAudioFile?

    var recorderAV: AKAudioRecorder?
    
    func setUpMixerChannels(sounds: Array<String>?) {
        
        for sound in sounds! {
            
            let fullNameArr = sound.componentsSeparatedByString(".")
            let title: String = fullNameArr[0]
            let type: String = fullNameArr[1]
            let file = NSBundle.mainBundle().pathForResource(title, ofType: type)
            
            // player -> pitch -> filter -> reverb -> mixer
            player = AKAudioPlayer(file!)
            pitcher = AKTimePitch(player!)
            filter = AKToneFilter(pitcher!)
            reverb = AKReverb(filter!)
            mixer.connect(reverb!)
            
            player!.looping = true
            player!.volume = 0
            reverb!.dryWetMix = 0
            soundlink[sound] = [player!, pitcher!, filter!, reverb!]
        }
        AudioKit.output = mixer
        AudioKit.start()
    }

    func playAudio(name: String) {
        print("playing right nowwww: ", name)
        player = soundlink[name]![0] as? AKAudioPlayer
        if player!.isStarted {
            player?.stop()
        } else {
            player?.start()
        }
    }
    
    func changePitch(name: String, level: Float) {
        pitcher = soundlink[name]![1] as? AKTimePitch
        if pitcher != nil {
            pitcher!.pitch = Double(level)
        }
    }

    func changeFilter(name: String, level: Float) {
        filter = soundlink[name]![2] as? AKToneFilter
        if filter != nil {
            filter!.halfPowerPoint = Double(level)
        }
    }
    
    func changeReverb(name: String, level: Float) {
        reverb = soundlink[name]![3] as? AKReverb
        if reverb != nil {
            reverb!.dryWetMix = Double(level)
        }
    }
    
    func changeVolume(name: String, level: Float) {
        player = soundlink[name]![0] as? AKAudioPlayer
        if player != nil {
            player!.volume = Double(level)
        }
    }
    
    func setUpRecorder() {
        
        // Set recorder paths etc.
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = NSURL(fileURLWithPath: dirPaths[0])
        let soundFilePath = docsDir.URLByAppendingPathComponent("sound.caf")
        let soundFileURL = NSURL(string: String(soundFilePath))

//        let recordSettings =
//            [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
//             AVEncoderBitRateKey: 16,
//             AVNumberOfChannelsKey: 2,
//             AVSampleRateKey: 44100.0]
        
        recorderAV = AKAudioRecorder(String(soundFileURL!))

//        print(".......... ", String(soundFilePath))
        
        
//        do {
//            recorderAV = try AVAudioRecorder(URL: soundFileURL!, settings: recordSettings as! [String : AnyObject])
//        } catch {
//            print("error")
//        }
//        if recorderAV!.prepareToRecord() == true {
//            print("prepared")
//        }
//        print(recorderAV!.url)
        
    }
    
    func record() {
        
        if recording == true {
            print("Recording stopped")
            recording = false
            recorderAV!.stop()

        } else {
            recording = true
//            if recorderAV!.record() == true {
//                print("really recording")
//            }
            recorderAV!.record()
        }
    }
}