//
//  AudioManager.swift
//  project
//
//  Created by Maarten Brijker on 02/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.

import Foundation
import AudioKit
import AVFoundation

class AudioManager {
   
    /**
     The AudioManager controlls all the sounds specifics and connects with Audio Kit Api.
     */
    
    // Hardcoded all the sounds in the tableview.
    var sounds = ["isinkvoices.wav", "kialabells.wav", "NINJASWORDloop.wav", "NASA.wav", "TCFsample.wav", "RFX6.WAV", "bolololo.wav", "TonalBell.aiff"]

    // MARK: - initializing the audio processors
    
    var player: AKAudioPlayer?
    var pitcher: AKTimePitch?
    var filter: AKToneFilter?
    var reverb: AKReverb?
    var mixer = AKMixer()
    
    // MARK: - Setting up the database and paths
    
    static let sharedInstance = AudioManager()
    private init() { }
    
    // Linking & storing all audiofiles with players and effects.
    var soundlink: [String: Array<AKNode>] = [:]
    
    // Recorders.
    var recording = false
    var MICrecorder: AVAudioRecorder?
    var OUTPUTrecorder: AKNodeRecorder?
    
    /// Returns a path for a specified type of file.
    func setPath(recordingType: String) -> NSURL {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = NSURL(fileURLWithPath: dirPaths[0])
        var soundFilePath = docsDir.URLByAppendingPathComponent("MICrecording.caf")
        
        if recordingType == "OUTPUT" {
            soundFilePath = docsDir.URLByAppendingPathComponent("OUTPUTrecording.caf")
        }
        return soundFilePath
    }
    
    /// Iterates over all the sounds and connects them to their AKNodes.
    func setUpMixerChannels() {
        print(sounds)
        
        var soundNr = 8
        var micNr = 1
        
        for sound in sounds {
            let soundArr = sound.componentsSeparatedByString(".")
            let title: String = soundArr[0]
            let type: String = soundArr[1]
            var file = NSBundle.mainBundle().pathForResource(title, ofType: type)
        
            let micCheck = sound.componentsSeparatedByString("recording")[0]
            
            if micCheck == "MIC" {
                let micTwo = sound.componentsSeparatedByString("recording")[1]
                let index = micTwo.startIndex.advancedBy(0)
                micNr = Int(String(micTwo[index]))! - soundNr + 1
                
                print("micTwo:", micTwo)
                print("micNr:", micNr)
            }
        
            if micCheck == "MIC"{
                
                // Get app project folder
                let filePlaceHolder = NSBundle.mainBundle().pathForResource("placeholder", ofType: ".wav")
                
                // Remove placeholder
                let withoutPlaceHolder = filePlaceHolder!.stringByReplacingOccurrencesOfString("placeholder.wav", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

                // Make new path
                let newFilePath = withoutPlaceHolder + "MICrecording\(micNr).caf"
                
                // Get Data of Mic recording.
                let soundFilePath = setPath("MIC")
                let soundFileURL = NSURL(string: String(soundFilePath))
                let soundData = NSData(contentsOfURL: soundFileURL!)
                
                // Write Data to project folder.
                if soundData != nil && sound == sounds.last! {
                    soundData?.writeToFile(newFilePath, atomically: true)
                }
                file = newFilePath
                print(file)
            }
            
            // player -> pitch -> filter -> reverb -> mixer
            player = AKAudioPlayer(file!)
            pitcher = AKTimePitch(player!)
            filter = AKToneFilter(pitcher!)
            reverb = AKReverb(filter!)
            mixer.connect(reverb!)
            
            player!.looping = true
            player!.volume = 0.1
            reverb!.dryWetMix = 0
            soundlink[sound] = [player!, pitcher!, filter!, reverb!]
        }
        AudioKit.output = mixer
        AudioKit.start()
    }

    // MARK: - Audio functions.

    func playAudio(name: String) {
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
    
    //MARK: - Audio recording.
    
    func setUpOUTPUTrecorder(soundFilePath: NSURL) {
        let soundFileURL = soundFilePath.path!
        OUTPUTrecorder = AKNodeRecorder(soundFileURL)
    }
    
    func recordOUTPUT() {
        if recording == true {
            recording = false
            OUTPUTrecorder!.stop()
        } else {
            recording = true
            OUTPUTrecorder!.record()
        }
    }
    
    // MARK: - MIC recording.
    
    /// Initiates the mic recording.
    func setUpMICRecorder(soundFilePath: NSURL) {
        
        let soundFileURL = NSURL(string: String(soundFilePath))
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]

        do {
            MICrecorder = try AVAudioRecorder(URL: soundFileURL!, settings: recordSettings as! [String : AnyObject])
        } catch {
            print("error")
        }
        if MICrecorder!.prepareToRecord() == true {
            print("mic = prepared")
        }
    }
    
    /// Starts and stops the mic recording.
    func recordMIC() {
        if recording {
            recording = false
            MICrecorder!.stop()
        } else {
            recording = true
            if MICrecorder!.record() == true {
            }
        }
    }
    
    // MARK: - Free Space manager
    
    // Taken from: http://stackoverflow.com/questions/5712527/how-to-detect-total-available-free-disk-space-on-the-iphone-ipad-device
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var attributes: [String: AnyObject]
        do {
            attributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(documentDirectoryPath.last! as String)
            let freeSize = attributes[NSFileSystemFreeSize] as? NSNumber
            if (freeSize != nil) {
                return freeSize?.longLongValue
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}