//
//  DropboxViewController.swift
//  project
//
//  Created by Maarten Brijker on 13/06/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
