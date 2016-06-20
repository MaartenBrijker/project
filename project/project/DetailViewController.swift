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

    var preValue: Float?
    var spacingIsOn = false
    
    var sounds = AudioManager.sharedInstance.sounds

    var started = false
    var player: AKAudioPlayer?
    
    var detailItem: AnyObject? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if detailItem != nil {
            self.title = "🔊🐬 \(detailItem!) 🐬🔊"
            
            // Set values of sliders.
            
            player = AudioManager.sharedInstance.soundlink[detailItem! as! String]![0] as? AKAudioPlayer
            volumeLevel.value = Float(player!.volume)

            let pitcher = AudioManager.sharedInstance.soundlink[detailItem! as! String]![1] as? AKTimePitch
            pitchLevel.value = Float(pitcher!.pitch)
            
            let filter = AudioManager.sharedInstance.soundlink[detailItem! as! String]![2] as? AKToneFilter
            filterLevel.value = Float(filter!.halfPowerPoint)
            
            let reverb = AudioManager.sharedInstance.soundlink[detailItem! as! String]![3] as? AKReverb
            reverbLevel.value = Float(reverb!.dryWetMix)
            
            if player!.isStarted {
                started = true
                self.startStopButton.setTitle("stop playing", forState: .Normal)
                self.view.backgroundColor = UIColor.cyanColor()
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
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBAction func startStopButton(sender: AnyObject) {
        if detailItem != nil {
            AudioManager.sharedInstance.playAudio(detailItem as! String)
            if player!.isPlaying {
                sender.setTitle("stop playing", forState: .Normal)
                UIView.animateWithDuration(0.7, animations: {
                    self.view.backgroundColor = UIColor.cyanColor()
                })
            } else {
                sender.setTitle("start playing", forState: .Normal)
                self.view.backgroundColor = UIColor.whiteColor()
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
    }

    func stopTimer() {
        self.timer.invalidate()
        self.filterLevel.setValue(preValue!, animated: true)
        AudioManager.sharedInstance.changeFilter(self.detailItem! as! String, level: preValue!)
        spacingIsOn = false
    }
    
    @IBAction func automateEffect(sender: AnyObject) {
        if detailItem != nil && !spacingIsOn {
            // Set value of filter before using the space wave.
            preValue = self.filterLevel.value
            var stopTimer: NSTimer
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(DetailViewController.delaying), userInfo: nil, repeats: true)
            stopTimer = NSTimer.scheduledTimerWithTimeInterval (3, target: self, selector: #selector(DetailViewController.stopTimer), userInfo: nil, repeats: false)
            spacingIsOn = true
        }
    }
}