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

        AudioManager.sharedInstance.setUpMixerChannels(sounds)
        
        // Set up Dropbox App Key.
        Dropbox.setupWithAppKey("fugkodmn29sklyj")
        
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

//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            objects.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
    
    // MARK: - Recording button.
    
    @IBAction func uploadButton(sender: AnyObject) {
        
//        let dropboxview = DropboxViewController()
//        
//        if (Dropbox.authorizedClient == nil) {
//            Dropbox.authorizeFromController(dropboxview)
//        } else {
//            print("User is already authorized!")
//        }
        
        
        
//        DropboxManager.sharedInstance.loginToDropbox()
//        
//        // get path to file
//        // pop up screen to change name of file
//        
//        DropboxManager.sharedInstance.uploadFile()
        
        
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

