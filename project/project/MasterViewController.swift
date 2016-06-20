//
//  MasterViewController.swift
//  project
//
//  Created by Maarten Brijker on 02/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.

import UIKit
import AudioKit
import SwiftyDropbox

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    var sounds: Array<String>?
    var starter = true
    var micIsRecording = true
    
    var progressAlert: UIAlertController?
    
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
        
        // Get values of recorders states.
        let micBool = checkRecordStatus("MIC")
        let outputBool = checkRecordStatus("OUTPUT")
        
        // Show alert error message if there isn't a recording file or users is still recording.
        if datadata == nil {
            showNoRecPopUp()
        } else if micBool || outputBool {
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
        
        // Set directory.
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        let soundFileURL = soundFilePath.path!
        
        // Get contents at path.
        let fileManager = NSFileManager.defaultManager()
        let datadata = fileManager.contentsAtPath(soundFileURL)
        
        // UPLOAD FILE.
        if datadata != nil {
            let dropBoxpath = "\(artistName)_\(trackTitle)_\(email).caf"
            let success = client!.files.upload(path: "/\(dropBoxpath)", body: datadata!)
            
            // Closure checking uploading progress.
            success.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            
                // Displaying percent that has been uploaded.
                let amountDone = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                self.showProgressPopUp(100.0 * amountDone)
                
                // Check whether upload was successful.
                if totalBytesRead == totalBytesExpectedToRead {
                    print("")
                    print(dropBoxpath)
                    
//                    print(self.checkUploadSuccess(client!, uploadedFileName: dropBoxPath))
                    
                    if !self.checkUploadSuccess(client!, uploadedFileName: dropBoxpath) {
                        self.showUploadFailedPopUp()
                    } else {
                        // show succes pop up
                    }
                }
            }
        }
    }
    
    func checkUploadSuccess(client: DropboxClient, uploadedFileName: String) -> Bool {
        // List folder
        var uploadSuccessful = false
        client.files.listFolder(path: "").response { response, error in
            print("*** List folder ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name, uploadedFileName)
                    if entry.name == uploadedFileName {
                        print("GOT HIM")
                        uploadSuccessful = true
                    }
                }
            } else {
                print(error!)
            }
        }
        return uploadSuccessful
    }
    
    // MARK: - Recording button

    @IBAction func recordButton(sender: AnyObject) {
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        
        // Get values of recorders states.
        let micBool = checkRecordStatus("MIC")
        
        // Warn user whether he is trying to rec multiple at the same time or rec limit is neared.
        if micBool == true {
            showMultipleRecPopUp()
        } else if starter {
            AudioManager.sharedInstance.setUpOUTPUTrecorder(soundFilePath)
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("stop recording", forState: .Normal)
            starter = false
            changeColors(starter)
        } else {
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("start recording", forState: .Normal)
            starter = true
            changeColors(starter)
        }
    }
    
    // MARK: - Microphone recorder
    
    @IBAction func micRecorder(sender: AnyObject) {
        let maxAllowedSounds = 10
        
        // Get values of recorders states.
        let outputBool = checkRecordStatus("OUTPUT")
        
        // Warn user whether he is trying to rec multiple at the same time or rec limit is neared.
        if outputBool == true {
            showMultipleRecPopUp()
        } else if AudioManager.sharedInstance.sounds.count >= maxAllowedSounds {
            showSoundConstraintPopUp()
        } else {
            let soundFilePath = AudioManager.sharedInstance.setPath("MIC")
            if micIsRecording {
                sender.setTitle("stop recording", forState: .Normal)
                startMicRecording(soundFilePath)
            } else {
                sender.setTitle("microphone", forState: .Normal)
                stopMicRecording(soundFilePath)
            }
            changeColors(micIsRecording)
        }
    }
    
    func startMicRecording(path: NSURL) {
        AudioManager.sharedInstance.setUpMICRecorder(path)
        AudioManager.sharedInstance.recordMIC()
        micIsRecording = false

    }
    
    func stopMicRecording(path: NSURL) {
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
    
    func checkRecordStatus(typeOfRec: String) -> Bool {

        // Get and return values of recorder state. If not initialized, set to false

        if typeOfRec == "MIC" {
            var micBool = AudioManager.sharedInstance.MICrecorder?.recording
            if micBool == nil {
                micBool = false
            }
            return micBool!
        } else {
            var outputBool = AudioManager.sharedInstance.OUTPUTrecorder?.isRecording
            if outputBool == nil {
                outputBool = false
            }
            return outputBool!
        }
    }
    
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
    
    func showProgressPopUp(amountDone: Float) {
        progressAlert = UIAlertController(title: "uploading...", message: "\(amountDone)%", preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(progressAlert!, animated: true, completion: {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func showUploadFailedPopUp() {
        let failedUploadAlert = UIAlertController(title: "E R R O R", message: "upload was unsuccessful... pls try again, maybe check ur internet connection?", preferredStyle: UIAlertControllerStyle.Alert)
        failedUploadAlert.addAction(UIAlertAction(title: "🆗", style: .Default, handler: { (action: UIAlertAction!) in
            failedUploadAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(failedUploadAlert, animated: true, completion: nil)
    }
    
    func showStopRecPopUp() {
        let plsStopRecAlert = UIAlertController(title: "E R R O R", message: "pls stop recording before u try to upload something", preferredStyle: UIAlertControllerStyle.Alert)
        plsStopRecAlert.addAction(UIAlertAction(title: "ON IT!", style: .Default, handler: { (action: UIAlertAction!) in
            plsStopRecAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(plsStopRecAlert, animated: true, completion: nil)
    }
    
    func showMultipleRecPopUp() {
        let noMultipleRecsAlert = UIAlertController(title: "E R R O R", message: "ur trying to record mic and output at the same time, pls stop one of these", preferredStyle: UIAlertControllerStyle.Alert)
        noMultipleRecsAlert.addAction(UIAlertAction(title: "ON IT!", style: .Default, handler: { (action: UIAlertAction!) in
            noMultipleRecsAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(noMultipleRecsAlert, animated: true, completion: nil)
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
        getUserInfoAlert.addAction(UIAlertAction(title: "↩", style: .Default, handler: { (action: UIAlertAction!) in
            getUserInfoAlert .dismissViewControllerAnimated(true, completion: nil)}))
        getUserInfoAlert.addAction(UIAlertAction(title: "🆙", style: .Default, handler: { (action: UIAlertAction!) in
            self.uploadingFile(getUserInfoAlert.textFields!)
        }))
        
        // Present alert.
        presentViewController(getUserInfoAlert, animated: true, completion: nil)
    }
    
    func showMicFailedPopUp() {
        let micAlert = UIAlertController(title: "error", message: "sorry ur mic recording wasn't saved", preferredStyle: UIAlertControllerStyle.Alert)
        micAlert.addAction(UIAlertAction(title: "😥", style: .Default, handler: { (action: UIAlertAction!) in
            micAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(micAlert, animated: true, completion: nil)
    }
    
    func showSoundConstraintPopUp() {
        let soundConstraintAlert = UIAlertController(title: "t o o o o o o o o o o  m u c h", message: "we need to keep the number of mic recordings limited", preferredStyle: UIAlertControllerStyle.Alert)
        soundConstraintAlert.addAction(UIAlertAction(title: "🚮", style: .Default, handler: { (action: UIAlertAction!) in
            soundConstraintAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(soundConstraintAlert, animated: true, completion: nil)
    }
}

