//
//  StatusMenuController.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Cocoa
import ScriptingBridge

class StatusMenuController: NSObject, NSMenuDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var websiteMenuItem: NSMenuItem!
    
    override func awakeFromNib() {
        statusMenu.delegate = self
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        websiteMenuItem.title = ScriptingManager.currentDomain ?? "No website"
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
}
