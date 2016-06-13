//
//  DropboxManager.swift
//  project
//
//  Created by Maarten Brijker on 13/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import Foundation
import SwiftyDropbox

class DropboxManager {
    
    static let sharedInstance = DropboxManager()
    
    private init() { }

    // API keys n stuff.
    let appKey = "fugkodmn29sklyj"
    let appSecret = "14o8b9gp6hyurr5"
//    let root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
    // You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
    // from https://dropbox.com/developers/apps
    

    let view = UIViewController()
    
    func loginToDropbox() {
        
        Dropbox.setupWithAppKey(appKey)
        
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(view)
        } else {
            print("User is already authorized!")
        }
        
//        // checking URL scheme.
//        if let authResult = Dropbox.handleRedirectURL() {
//            switch authResult {
//            case .Success(let token):
//                print("Success! User is logged into Dropbox.")
//            case .Error(let error, let description):
//                print("Error: \(description)")
//            }
//        }
        
    }
    
    
    
    
    func uploadFile() {
        // check if file is legit
        // check if connection has been made
        // upload file to dropbox
        // check whether file has been uploaded (message)
    }
    
    
    
}