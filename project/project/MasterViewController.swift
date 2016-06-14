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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up mixer sounds with effects and connect mixer channels.
        AudioManager.sharedInstance.setUpMixerChannels(sounds)
        
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
        
        // Authorize user.
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
//        Dropbox.authorizeFromController(self)
        
        // Uploading a sound file.
        uploadingFile()
    }
    
    func uploadingFile() {
        
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
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
            
            // The path to the file
//            let path = "/Users/maartenbrijker/Library/Developer/CoreSimulator/Devices/742D170F-991C-48B0-BC07-7419C86C4036/data/Containers/Data/Application/3090653F-5FB8-43FE-B8F9-577C5EE21C14/Documents/sound.caf"
//            print(path)
//            
            // Set directory
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir = NSURL(fileURLWithPath: dirPaths[0])
            let soundFilePath = docsDir.URLByAppendingPathComponent("sound.caf")
            let soundFileURL = soundFilePath.path!
            
            
            let fileManager = NSFileManager.defaultManager()
            
            let datadata = fileManager.contentsAtPath(soundFileURL)
            
            print("")
            
            if datadata != nil {
                print("lesoooooo")
                client.files.upload(path: "/testingga.caf", body: datadata!)
            }
//            // Upload a file
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

