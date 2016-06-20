//
//  MasterViewController.swift
//  project
//
//  Created by Maarten Brijker on 02/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit
import AudioKit
import SwiftyDropbox

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    var sounds: Array<String>?
    var starter = true
    var micIsRecording = true
    
    var clienttest: DropboxClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sounds = AudioManager.sharedInstance.sounds

        // Set up mixer sounds with effects and connect mixer channels.
        AudioManager.sharedInstance.setUpMixerChannels()
        
        // Accestoken
        let accessToken = "XPA_hvP23MAAAAAAAAAAFyLTeXC7cSemXHa-Y3chHcV-lP0wiULlKtnqSCZHdKlX"
        let uid = "DEVXXX"
        clienttest = DropboxClient(accessToken: DropboxAccessToken(accessToken: accessToken, uid: uid))
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        sounds = AudioManager.sharedInstance.sounds
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = sounds![indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let soundArr = sounds![indexPath.row].componentsSeparatedByString(".")
        let object = soundArr[0]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - DROPBOXSTUFF
    
    @IBAction func uploadButton(sender: AnyObject) {
        
        // Set directory
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        let soundFileURL = soundFilePath.path!
        
        // Get contents at path
        let fileManager = NSFileManager.defaultManager()
        let datadata = fileManager.contentsAtPath(soundFileURL)
        
        // TODO ---- show alert error message if there isn't a recording file
        if datadata == nil {
            showNoRecPopUp()
        } else if micIsRecording || starter {
            showStopRecPopUp()
        } else {
            // Pop up alert message, asking user for input, thereafter move on to upload function.
            showUploadPopUp()
        }
    }
    
    /// Required a function for uploadingFile (function), should be able to delete this later. TODO!
    func tryout() {
    }
    
    func uploadingFile(userData: Array<UITextField>) {
        
        // Assign submitted values.
        let artistName = userData[0].text!
        let trackTitle = userData[1].text!
        let email = userData[2].text!
        
        // TODO ---- make alert message if authorization problems occur
        
        // Verify user is logged into Dropbox
        let client = clienttest
        
        // Get the current user's account info
        client!.users.getCurrentAccount().response { response, error in
            print("*** Get current account ***")
            if let account = response {
                print("Hello \(account.name.givenName)!")
            } else {
                print(error!)
            }
            
            // Set directory
            let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
            let soundFileURL = soundFilePath.path!

            // TODO ---- show alert error message if there isn't a recording file
            
            // TODO ---- convert file to WAV
//            let wavPath = self.convertFileToExtension(soundFileURL, path: String(soundFileURL))
            
            // Get contents at path
            let fileManager = NSFileManager.defaultManager()
            let datadata = fileManager.contentsAtPath(soundFileURL)
//            let datadata = fileManager.contentsAtPath(wavPath)
            
            // UPLOAD FILE.
            if datadata != nil {
                client!.files.upload(path: "/\(artistName)_\(trackTitle)_\(email).caf", body: datadata!)
                
                // TODO ---- Let user know, upload was succesfull, alertmessage.
            }
        }
    }
    
//    /// Doesnt work as expected, prob deleting this function
//    func convertFileToExtension(dataURL: String, path: String) -> String{
//        // Conversion path to write to
//        let changedExtension = path.stringByReplacingOccurrencesOfString(".caf", withString: ".wav", options: NSStringCompareOptions.LiteralSearch, range: nil)
//
//        // GET DATA from old .caf file
//        let dataURL = NSURL(fileURLWithPath: dataURL)
//        let soundData = NSData(contentsOfURL: dataURL)
//
//        // Write Data to new .wav file
//        if soundData != nil {
//            soundData?.writeToFile(changedExtension, atomically: true)
//            print("not nil", changedExtension)
//        }
//        return changedExtension
//    }
    
    // MARK: - Recording button

    @IBAction func recordButton(sender: AnyObject) {
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        if starter {
            AudioManager.sharedInstance.setUpOUTPUTrecorder(soundFilePath)
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("stop recording", forState: .Normal)
            starter = false
        } else {
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("start recording", forState: .Normal)
            starter = true
        }
        changeColors(starter)
    }
    
    // MARK: - Microphone recorder
    
    @IBAction func micRecorder(sender: AnyObject) {
        let maxAllowedSounds = 10
        if AudioManager.sharedInstance.sounds.count >= maxAllowedSounds {
            showSoundConstraintPopUp()
        } else {
            let soundFilePath = AudioManager.sharedInstance.setPath("MIC")
            if micIsRecording {
                sender.setTitle("stop recording", forState: .Normal)
                startRecording(soundFilePath)
            } else {
                sender.setTitle("microphone", forState: .Normal)
                stopRecording(soundFilePath)
            }
        }
        changeColors(micIsRecording)
    }
    
    func startRecording(path: NSURL) {
        AudioManager.sharedInstance.setUpMICRecorder(path)
        AudioManager.sharedInstance.recordMIC()
        micIsRecording = false

    }
    
    func stopRecording(path: NSURL) {
        AudioManager.sharedInstance.recordMIC()
        micIsRecording = true
        let soundFileURL = path.path!
        
        // If recording was succesfull: update audio inputs, else: alert user.
        if doesFileExist(soundFileURL) {
            AudioManager.sharedInstance.sounds.append("MICrecording\(sounds!.count).caf")
            updateTableView()
            AudioManager.sharedInstance.setUpMixerChannels() //update mixerchannels with mic
        } else {
            showMicFailedPopUp()
        }
    }
    
    // MARK: - Checking/updating/coloring
    
    /// Checks if file exists at specified path.
    func doesFileExist(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
    
    /// Updates the Table View.
    func updateTableView() {
        sounds = AudioManager.sharedInstance.sounds
        self.tableView.reloadData()
    }
    
    /// Changes background color to show a recording is taking place.
    func changeColors(state: Bool) {
        if state {
            UIView.animateWithDuration(0.7, animations: {
                self.view.backgroundColor = UIColor.whiteColor()
            })
        } else {
            UIView.animateWithDuration(0.7, animations: {
                self.view.backgroundColor = UIColor.redColor()
            })
        }
    }
    
    // MARK: - Pop Up Screens
    
    func showStopRecPopUp() {
        let plsStopRecAlert = UIAlertController(title: "E R R O R", message: "pls stop recording before u try to upload something", preferredStyle: UIAlertControllerStyle.Alert)
        plsStopRecAlert.addAction(UIAlertAction(title: "ON IT!", style: .Default, handler: { (action: UIAlertAction!) in
            plsStopRecAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(plsStopRecAlert, animated: true, completion: nil)
        
    }
    
    func showNoRecPopUp() {
        let noRecFileAlert = UIAlertController(title: "E R R O R", message: "pls make a audiorecording before u try to upload something", preferredStyle: UIAlertControllerStyle.Alert)
        noRecFileAlert.addAction(UIAlertAction(title: "OK LETS DO THIS!", style: .Default, handler: { (action: UIAlertAction!) in
            noRecFileAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(noRecFileAlert, animated: true, completion: nil)
    }
    
    func showUploadPopUp() {
        
        // Initiate alert.
        let getUserInfoAlert = UIAlertController(title: "U P L O A D I N G", message: "state us some info pls", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add text fields and button.
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(artistName) -> Void in artistName.placeholder = "<artist name>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(trackTitle) -> Void in trackTitle.placeholder = "<track title>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(email) -> Void in email.placeholder = "<email (optional)>"}
        getUserInfoAlert.addAction(UIAlertAction(title: "🎇", style: .Default, handler: { (action: UIAlertAction!) in
            getUserInfoAlert .dismissViewControllerAnimated(true, completion: nil)}))
        getUserInfoAlert.addAction(UIAlertAction(title: "🎆🆙🎆", style: .Default, handler: { (action: UIAlertAction!) in
            self.uploadingFile(getUserInfoAlert.textFields!)
        }))
        
        // Present alert.
        presentViewController(getUserInfoAlert, animated: true, completion: nil)
    }
    
    func showMicFailedPopUp() {
        let micAlert = UIAlertController(title: "error", message: "sorry your mic recording wasn't saved", preferredStyle: UIAlertControllerStyle.Alert)
        micAlert.addAction(UIAlertAction(title: "😥", style: .Default, handler: { (action: UIAlertAction!) in
            micAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(micAlert, animated: true, completion: nil)
    }
    
    func showSoundConstraintPopUp() {
        let soundConstraintAlert = UIAlertController(title: "t o o o o o o o o o o  m u c h", message: "we need to keep the number of mic recordings limited", preferredStyle: UIAlertControllerStyle.Alert)
        soundConstraintAlert.addAction(UIAlertAction(title: "😮 🚮 😮", style: .Default, handler: { (action: UIAlertAction!) in
            soundConstraintAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(soundConstraintAlert, animated: true, completion: nil)
    }
}

