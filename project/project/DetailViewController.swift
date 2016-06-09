//
//  DetailViewController.swift
//  project
//
//  Created by Maarten Brijker on 02/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit
import AudioKit

class DetailViewController: UIViewController {
    var timer: NSTimer!

    var sounds = ["isinkcomb.wav", "isinkvoices.wav", "kialabells.wav", "NASA.wav", "bolololo.wav", "TonalBell.aiff"]

    var starter = true
    
    var detailItem: AnyObject? {
        didSet {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if detailItem != nil {
            self.title = "🔊🐬 \(detailItem!) 🐬🔊"
            
            // Set values of sliders.
            
            let player = AudioManager.sharedInstance.soundlink[detailItem! as! String]![0] as? AKAudioPlayer
            volumeLevel.value = Float(player!.volume)

            let pitcher = AudioManager.sharedInstance.soundlink[detailItem! as! String]![1] as? AKTimePitch
            pitchLevel.value = Float(pitcher!.pitch)
            
            let filter = AudioManager.sharedInstance.soundlink[detailItem! as! String]![2] as? AKToneFilter
            filterLevel.value = Float(filter!.halfPowerPoint)
            
            let reverb = AudioManager.sharedInstance.soundlink[detailItem! as! String]![3] as? AKReverb
            reverbLevel.value = Float(reverb!.dryWetMix)
            
            if player!.isStarted {
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBOutlet weak var pitchLevel: UISlider!
    @IBAction func pitchSlider(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.changePitch(detailItem! as! String, level: pitchLevel.value)
        }
    }

    @IBOutlet weak var filterLevel: UISlider!
    @IBAction func filterSlider(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.changeFilter(detailItem! as! String, level: filterLevel.value)
        }
    }
    
    @IBOutlet weak var reverbLevel: UISlider!
    @IBAction func reverbSlider(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.changeReverb(detailItem! as! String, level: reverbLevel.value)
        }
    }
    
    @IBOutlet weak var volumeLevel: UISlider!
    @IBAction func volumeSlider(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.changeVolume(detailItem! as! String, level: volumeLevel.value)
        }
    }
    
    @IBAction func startStopButton(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.playAudio(detailItem as! String)
            if sender.currentTitle == "start playing" {
                sender.setTitle("stop playing", forState: .Normal)
            } else {
                sender.setTitle("start playing", forState: .Normal)
            }
        }
    }
    
    func delaying() {
        let value = arc4random_uniform(UInt32(self.filterLevel.maximumValue))
        AudioManager.sharedInstance.changeFilter(self.detailItem! as! String, level: Float(value))
        self.filterLevel.setValue(Float(value), animated: true)
        
//        let value = arc4random_uniform(UInt32(self.pitchLevel.maximumValue))
//        AudioManager.sharedInstance.changePitch(self.detailItem! as! String, level: Float(value))
//        self.pitchLevel.setValue(Float(value), animated: true)

//        let value = arc4random_uniform(UInt32(100))
//        let secondval = Float(Float(value) * 0.01)
//        AudioManager.sharedInstance.changeReverb(self.detailItem! as! String, level: secondval)
//        self.reverbLevel.setValue(secondval, animated: true)

        print("value = ", value)
    }

    func stopTimer () {
      self.timer.invalidate()
    }
    
    @IBAction func automateEffect(sender: AnyObject) {
        if detailItem != nil {
            
            var stopTimer: NSTimer

            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(DetailViewController.delaying), userInfo: nil, repeats: true)
            
            stopTimer = NSTimer.scheduledTimerWithTimeInterval (3, target: self, selector: #selector(DetailViewController.stopTimer), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func recordButton(sender: AnyObject) {
        if starter == true {
            AudioManager.sharedInstance.setUpOUTPUTrecorder()
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("stop recording", forState: .Normal)
            starter = false
        } else {
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("start recording", forState: .Normal)
            starter = true
        }
    }
    
}