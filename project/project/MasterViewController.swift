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

    var sounds = ["isinkcomb.wav", "isinkvoices.wav", "kialabells.wav", "NASA.wav", "bolololo.wav", "TonalBell.aiff"]
    
    var starter = true
    
    var clienttest: DropboxClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up mixer sounds with effects and connect mixer channels.
        AudioManager.sharedInstance.setUpMixerChannels(sounds)
        
        // Accestoken
        let accessToken = "XPA_hvP23MAAAAAAAAAAFyLTeXC7cSemXHa-Y3chHcV-lP0wiULlKtnqSCZHdKlX"
        let uid = "DEVXXX"
        clienttest = DropboxClient(accessToken: DropboxAccessToken(accessToken: accessToken, uid: uid))
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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

        let object = sounds[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: - DROPBOXSTUFF.
    
    @IBAction func uploadButton(sender: AnyObject) {
        
//        // Authorize user.
//        if (Dropbox.authorizedClient == nil) {
//            Dropbox.authorizeFromController(self)
//        } else {
//            print("User is already authorized!")
//        }
//        Dropbox.authorizeFromController(self)
        
        // Uploading a sound file.
        uploadingFile()
    }
    
    func tryout() {
        print("              block block block              ")
    }
    
    func uploadingFile() {
        
        // make alert message if user is not authorized yet
        
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
        
        
        // List folder
        client!.files.listFolder(path: "").response { response, error in
            print("*** List folder ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name)
                }
            } else {
                print(error!)
            }
        }
            
            // Set directory
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir = NSURL(fileURLWithPath: dirPaths[0])
            let soundFilePath = docsDir.URLByAppendingPathComponent("sound.caf")
            let soundFileURL = soundFilePath.path!
            
            let fileManager = NSFileManager.defaultManager()
            
            let datadata = fileManager.contentsAtPath(soundFileURL)
            
            // TODO ---- show alert error message if there isn't a recording file
            
            // TODO ---- convert file to WAV?
            
            let asset = AVAsset(URL: NSURL(fileURLWithPath: soundFileURL))
            let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            session!.outputURL = NSURL(string: soundFileURL)
            session!.directoryForTemporaryFiles = session!.outputURL
            session!.outputFileType = AVFileTypeAppleM4A
            print(session!.estimatedOutputFileLength)
            session!.exportAsynchronouslyWithCompletionHandler(self.tryout)
            
            print(soundFileURL)
            
            // TODO ---- show alert box, asking user to pick artistname_tracktitel_mail

            
            // UPLOAD FILE
            if datadata != nil {
                client!.files.upload(path: "/dissssss.m4a", body: datadata!)
            }
            
            
            
//            // Upload a file (dropbox example code adjusted)
////            let fileData = "Hello!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//            client.files.upload(path: "/test.caf", body: datadata!).response { response, error in
//                if let metadata = response {
//                    print("*** Upload file ****")
//                    print("Uploaded file name: \(metadata.name)")
//                    print("Uploaded file revision: \(metadata.rev)")
//                    
//                    // Get file (or folder) metadata
//                    client.files.getMetadata(path: "/test.caf").response { response, error in
//                        print("*** Get file metadata ***")
//                        if let metadata = response {
//                            if let file = metadata as? Files.FileMetadata {
//                                print("This is a file with path: \(file.pathLower)")
//                                print("File size: \(file.size)")
//                            } else if let folder = metadata as? Files.FolderMetadata {
//                                print("This is a folder with path: \(folder.pathLower)")
//                            }
//                        } else {
//                            print(error!)
//                        }
//                    }
//                } else {
//                    print(error!)
//                }
//            }
        }
    }
    
    // MARK: - Recording button.

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

