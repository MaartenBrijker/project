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

    var sounds = AudioManager.sharedInstance.sounds
    
    var starter = true
    var micIsRecording = true
    
    var clienttest: DropboxClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up mixer sounds with effects and connect mixer channels.
        AudioManager.sharedInstance.setUpMixerChannels(sounds)
        
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

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = sounds[indexPath.row]
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
        return sounds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let soundArr = sounds[indexPath.row].componentsSeparatedByString(".")
        let object = soundArr[0]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: - DROPBOXSTUFF
    
    @IBAction func uploadButton(sender: AnyObject) {
        
        // Pop up alert message, asking user for input, thereafter move on to upload function.
        showPopUp()

    }
    
    func tryout() {
    }
    
    func showPopUp() {
        
        // Initiate alert.
        let getUserInfoAlert = UIAlertController(title: "U P L O A D I N G", message: "state us some info pls", preferredStyle: UIAlertControllerStyle.Alert)

        // Add text fields and button.
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(artistName) -> Void in artistName.placeholder = "<artist name>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(trackTitle) -> Void in trackTitle.placeholder = "<track title>"}
        getUserInfoAlert.addTextFieldWithConfigurationHandler {(email) -> Void in email.placeholder = "<email (optional)>"}
        getUserInfoAlert.addAction(UIAlertAction(title: "cancel", style: .Default, handler: { (action: UIAlertAction!) in
            getUserInfoAlert .dismissViewControllerAnimated(true, completion: nil)}))
        getUserInfoAlert.addAction(UIAlertAction(title: "upload", style: .Default, handler: { (action: UIAlertAction!) in
            self.uploadingFile(getUserInfoAlert.textFields!)
        }))
        
        // Present alert.
        presentViewController(getUserInfoAlert, animated: true, completion: nil)
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
            let soundFilePath = self.setPath("OUTPUT")
            let soundFileURL = soundFilePath.path!

            
            // Get contents at path
            let fileManager = NSFileManager.defaultManager()
            let datadata = fileManager.contentsAtPath(soundFileURL)
            
            // TODO ---- show alert error message if there isn't a recording file
            
            // TODO ---- convert file to m4a?
            
            let asset = AVAsset(URL: NSURL(fileURLWithPath: soundFileURL))
            let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            session!.outputURL = NSURL(string: soundFileURL)
            session!.directoryForTemporaryFiles = session!.outputURL
            session!.outputFileType = AVFileTypeAppleM4A
            print(session!.estimatedOutputFileLength)
            session!.exportAsynchronouslyWithCompletionHandler(self.tryout)
            
            // UPLOAD FILE.
            if datadata != nil {
                client!.files.upload(path: "/\(artistName)_\(trackTitle)_\(email).caf", body: datadata!)
                
                // TODO ---- Let user know, upload was succesfull, alertmessage.
            }
        }
    }
    
    func setPath(recordingType: String) -> NSURL {
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = NSURL(fileURLWithPath: dirPaths[0])
        
        var soundFilePath = docsDir.URLByAppendingPathComponent("MICrecording.caf")
        
        if recordingType == "OUTPUT" {
            soundFilePath = docsDir.URLByAppendingPathComponent("OUTPUTrecording.caf")
        }
        
//        let soundFileURL = soundFilePath.path!
//        return soundFileURL
        return soundFilePath
    }
    
    // MARK: - Recording button

    @IBAction func recordButton(sender: AnyObject) {
        let soundFilePath = setPath("OUTPUT")
        
        if starter == true {
            AudioManager.sharedInstance.setUpOUTPUTrecorder(soundFilePath)
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("stop recording", forState: .Normal)
            starter = false
        } else {
            AudioManager.sharedInstance.recordOUTPUT()
            sender.setTitle("start recording", forState: .Normal)
            starter = true
        }
    }
    
    // MARK: - Microphone recorder
    
    @IBAction func micRecorder(sender: AnyObject) {
        let soundFilePath = setPath("MIC")
        if micIsRecording {
            AudioManager.sharedInstance.setUpMICRecorder(soundFilePath)
            AudioManager.sharedInstance.recordMIC()
            micIsRecording = false
        } else {
            AudioManager.sharedInstance.recordMIC()
            micIsRecording = true
            let soundFileURL = soundFilePath.path!

            // If recording was succesfull: update audio inputs, else: alert user.
            if contentsOfDirectoryAtPath(soundFileURL) {
                
                
                
                
            } else {
                // TODO ---- alert message
            }
        }
    }
    
    /// Checks if file exists at specified path.
    func contentsOfDirectoryAtPath(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
}

