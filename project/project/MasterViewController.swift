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

    /**
     The masterviewcontroller storing:
     
     - Tableview: displaying all the audiofiles.
     - UploadButton: for uploading to dropbox.
     - RecordButton: recording audio output in real time.
     - MicrophoneButton: for recording audio over the mic and storing this in the audiofiles table.
     */

    // For the next screen.
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    // Sound storing and boolians to check states.
    var sounds: Array<String>?
    var starter = true
    var micIsRecording = true
    var typeOfRecording = "OUTPUT"
    
    // User for the free space checking.
    let maxKbPerSec = 1411.20       // bit rate per sec uncompressed
    let maxBytePerSecond = 187500   // maxKbPerSec * kbps (0.0001333) with a bit of marge
    
    // Texts used for the alert action.
    let errorTitle = "E R R O R"
    let onItAction = "ON IT"
    let stopRecMessage = "pls stop recording before u try to upload something"
    let uploadUnsuccessfulMessage = "upload was unsuccessful... pls try again, maybe check ur internet connection and validity of tracktitle etc?"
    let multipleRecMessage = "ur trying to record mic and output at the same time, pls stop one of these"
    let noRecFileMessage = "pls make a audiorecording before u try to upload something"
    let noRecFileAction = "OK LETS DO THIS!"
    let uploadSuccessfulTitle = "C O N G R A T Z"
    let uploadSuccessfulAction = "was uploaded"
    let micFailedMessage = "sorry ur mic recording wasn't saved"
    let micFailedAction = "😥"
    let micConstraintTitle = "t o o o o o o o o o o  m u c h"
    let micConstraintMessage = "we need to keep the number of mic recordings limited"
    let micConstraintAction = "🚮"
    let lowFreeSpaceMessage = "ur device is getting low on free space, we need to cancel the recording..."
    
    // In order to connect to Dropbox properly.
    var personalClient: DropboxClient?
    let accessToken = "XPA_hvP23MAAAAAAAAAAFyLTeXC7cSemXHa-Y3chHcV-lP0wiULlKtnqSCZHdKlX"
    let uid = "DEVXXX"
    var uploadError: String?
    
    /// Setting up all the sounds in the AudioManager file and initiating a NSNotificationcenter.
    override func viewDidLoad() {
        super.viewDidLoad()
        sounds = AudioManager.sharedInstance.sounds
        AudioManager.sharedInstance.setUpMixerChannels()
        personalClient = DropboxClient(accessToken: DropboxAccessToken(accessToken: accessToken, uid: uid))
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showError), name: "uploadError", object: nil)
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

    // MARK: - Segues.
    
    /// Letting the detailview know which sound was selected.
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

    // MARK: - Table View.

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds!.count
    }
    
    /// Displaying all the sound names in the table.
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
    
    // MARK: - Dropbox.
    
    /// Gets the content to upload and checks whether there are no initial error messages.
    @IBAction func uploadButton(sender: AnyObject) {
        
        // Set directory
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        let soundFileURL = soundFilePath.path!
        
        // Get contents at path
        let fileManager = NSFileManager.defaultManager()
        let data = fileManager.contentsAtPath(soundFileURL)
        
        // Get values of recorders states.
        let micBool = checkRecordStatus("MIC")
        let outputBool = checkRecordStatus("OUTPUT")
        
        // Show alert error message if there isn't a recording file or users is still recording.
        if data == nil {
            showSimplePopUp(errorTitle, message: noRecFileMessage, action: noRecFileAction)
        } else if micBool || outputBool {
            showSimplePopUp(errorTitle, message: stopRecMessage, action: onItAction)
        } else {
            // Pop up alert message, asking user for input, thereafter move on to upload function.
            showUploadPopUp(sender, soundData: data!)
        }
    }
    
    /// Gets called after the user fills in his info and connects to Dropbox.
    func initiatingUpload(userData: Array<UITextField>, button: AnyObject, soundData: NSData) {
        // Assign submitted values and remove invalid characters.
        let artistName = userData[0].text!
        let trackTitle = userData[1].text!
        let email = userData[2].text!
        let preName = "\(artistName)_\(trackTitle)_\(email).caf"
        let dropboxPath = removeInvalidCharacters(preName)
        
        // Makes a Dropbox client and upload file
        let client = personalClient
        uploadingFile(soundData, path: dropboxPath, client: client!, button: button)
    }
    
    func uploadingFile(data: NSData, path: String, client: DropboxClient, button: AnyObject) {
        let uploading = client.files.upload(path: "/\(path)", body: data)
        self.showPleaseWaitPopUp(true)
        
        // Closure checking uploading progress.
        uploading.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            
            // Displaying percent that has been uploaded.
            let amountDone = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
            button.setTitle("\(100.0 * amountDone)%", forState: .Normal)
            print(100.0 * amountDone)  // remove later
            if amountDone == 1.0 {
                button.setTitle("upload", forState: .Normal)
                self.showPleaseWaitPopUp(false)
            }
        }
        
        // Check whether upload was successful and alert the user.
        uploading.response({ (response, error) in
            if let metadata = response {
                self.showSimplePopUp(self.uploadSuccessfulTitle, message: "\(metadata.name)", action: self.uploadSuccessfulAction)
            } else {
                self.uploadError = String(error)
                self.showPleaseWaitPopUp(false)
            }
        })
    }
    
    /// Lets the Notification center know it should display the error.
    func postNotification() {
        print("initiate")
        NSNotificationCenter.defaultCenter().postNotificationName("uploadError", object: nil)
    }

    /// Displays the error, if the case, that Dropbox returns in a alert message.
    func showError() {
        self.showSimplePopUp(self.errorTitle, message: "\(uploadError) \(self.uploadUnsuccessfulMessage)", action: "🆗")
    }
    
    // MARK: - Output recorder
    
    /// Initiates a path to the directory where the file is stored and sets a timer checking for free space.
    @IBAction func recordButton(sender: AnyObject) {
        
        // Get path to file and values of recorders states.
        let soundFilePath = AudioManager.sharedInstance.setPath("OUTPUT")
        let micBool = checkRecordStatus("MIC")
        
        // Warn user whether he is trying to rec multiple at the same time or rec limit is neared.
        if micBool == true {
            showSimplePopUp(errorTitle, message: multipleRecMessage, action: onItAction)
        } else if starter {
            // Initiate time check function and start recording.
            checkBytesWrite("MIC")
            startOutputRecording(soundFilePath)
            sender.setTitle("stop recording", forState: .Normal)
        } else {
            sender.setTitle("start recording", forState: .Normal)
            stopOutputRecording()
        }
    }
    
    /// Starts the audio recording in the AudioManager class and changes the background color.
    func startOutputRecording(path: NSURL) {
        AudioManager.sharedInstance.setUpOUTPUTrecorder(path)
        AudioManager.sharedInstance.recordOUTPUT()
        starter = false
        changeColors(starter)
    }
    
    /// Stops the audio recording in the AudioManager class and clears the background color.
    func stopOutputRecording() {
        AudioManager.sharedInstance.recordOUTPUT()
        starter = true
        changeColors(starter)
    }
    
    // MARK: - Microphone recorder
    
    /// Initiates a path to the directory where the micrecording is stored and sets a timer checking for free space.
    @IBAction func micRecorder(sender: AnyObject) {
        let maxAllowedSounds = 10
        
        // Get values of recorders states.
        let outputBool = checkRecordStatus("OUTPUT")
        
        // Warn user whether he is trying to rec multiple at the same time or rec limit is neared.
        if outputBool == true {
            showSimplePopUp(errorTitle, message: multipleRecMessage, action: onItAction)
        } else if AudioManager.sharedInstance.sounds.count >= maxAllowedSounds {
            showSimplePopUp(micConstraintTitle, message: micConstraintMessage, action: micConstraintAction)
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
    
    /// Starts the mic recording in the AudioManager class and changes the background color.
    func startMicRecording(path: NSURL) {
        AudioManager.sharedInstance.setUpMICRecorder(path)
        AudioManager.sharedInstance.recordMIC()
        micIsRecording = false
    }
    
    /// Stops the mic recording in the AudioManager class and clears the background color.
    func stopMicRecording(path: NSURL) {
        AudioManager.sharedInstance.recordMIC()
        micIsRecording = true
        let soundFileURL = path.path!
        checkMicSuccess(soundFileURL)
    }
    
    /// Checks whether the mic file is really there and if so, updates the table view.
    func checkMicSuccess(soundFileURL: String) {
        // If recording was succesfull: update audio inputs, else: alert user.
        if doesFileExist(soundFileURL) {
            AudioManager.sharedInstance.sounds.append("MICrecording\(sounds!.count).caf")
            updateTableView()
            AudioManager.sharedInstance.setUpMixerChannels() //update mixerchannels with mic
        } else {
            showSimplePopUp(errorTitle, message: micFailedMessage, action: micFailedAction)
        }
    }
    
    // MARK: - Checking/updating/coloring
    
    /// Removes all invalid characters from the filename that is about to be uploaded to Dropbox.
    func removeInvalidCharacters(filename: String) -> String {
        let filename1 = filename.stringByReplacingOccurrencesOfString("/", withString: "")
        let filename2 = filename1.stringByReplacingOccurrencesOfString("\\", withString: "")
        let filename3 = filename2.stringByReplacingOccurrencesOfString("\n", withString: "")
        let filename4 = filename3.stringByReplacingOccurrencesOfString(":", withString: "")
        return filename4
    }
    
    /// Checks the amount of free space, converts this to amount of time that can be recorded and initiates a times to take care hereof.
    func checkBytesWrite(theType: String) {
        typeOfRecording = theType
        let totalFreeSpaceInBytes = AudioManager.sharedInstance.deviceRemainingFreeSpaceInBytes()
        let maxWritingTime = Float(totalFreeSpaceInBytes!) / Float(maxBytePerSecond)
        // Stops the recording process if 90% of the free space on the device is taken.
        NSTimer.scheduledTimerWithTimeInterval(Double(0.9 * maxWritingTime), target: self, selector: #selector(MasterViewController.gettingLowOnFreeSpace), userInfo: nil, repeats: false)
    }
    
    /// Gets called after the times fires when free space is low. Stops the audio recording and alerts the user.
    func gettingLowOnFreeSpace() {
        if typeOfRecording == "MIC" {
            AudioManager.sharedInstance.recordMIC()
            micIsRecording = true
        } else {
            stopOutputRecording()
        }
        showSimplePopUp(errorTitle, message: lowFreeSpaceMessage, action: micFailedAction)
    }
    
    /// Checks whether mic or output is recording in order to make sure this doesn't happen in the same time.
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
    
    /// Updates the Table View with new sounds.
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
    
    /// Shows a simple alert screen with a title, message and action button.
    func showSimplePopUp(title: String, message: String, action: String) {
        let theAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        theAlert.addAction(UIAlertAction(title: action, style: .Default, handler: { (action: UIAlertAction!) in
            theAlert .dismissViewControllerAnimated(true, completion: nil)}))
        presentViewController(theAlert, animated: false, completion: nil)
    }
    
    /// Shows a simple alert screen asking user to wait while uploading, disabling all app's buttons.
    func showPleaseWaitPopUp(state: Bool) {
        let theAlert = UIAlertController(title: "U P L O A D I N G", message: "please wait till ur file is uploaded, that could take some time...", preferredStyle: UIAlertControllerStyle.Alert)
        
        if state {
            presentViewController(theAlert, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(false, completion: postNotification)
        }
    }
    
    /// Asks user to fill in his title and artist name for uploading the file to Dropbox.
    func showUploadPopUp(button: AnyObject, soundData: NSData) {
        // Initiate alert.
        let getUserInfoAlert = UIAlertController(title: "U P L O A D I N G", message: "state us some info pls", preferredStyle: UIAlertControllerStyle.Alert)
        // Add text fields and button.
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(artistName) -> Void in artistName.placeholder = "<artist name>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(trackTitle) -> Void in trackTitle.placeholder = "<track title>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(email) -> Void in email.placeholder = "<email (optional)>"}
        getUserInfoAlert.addAction(UIAlertAction(title: "↩", style: .Default, handler: { (action: UIAlertAction!) in
            getUserInfoAlert .dismissViewControllerAnimated(true, completion: nil)}))
        getUserInfoAlert.addAction(UIAlertAction(title: "🆙", style: .Default, handler: { (action: UIAlertAction!) in
            self.initiatingUpload(getUserInfoAlert.textFields!, button: button, soundData: soundData)
        }))
        // Present alert.
        presentViewController(getUserInfoAlert, animated: true, completion: nil)
    }
}