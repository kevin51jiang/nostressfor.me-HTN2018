//
//  AppDelegate.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Cocoa
import ScriptingBridge
import AXSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let icon = #imageLiteral(resourceName: "menuIcon")
        icon.isTemplate = true
        DispatchQueue.main.async {
            self.statusItem.button?.image = icon
        }
        statusItem.menu = statusMenu
//        statusItem.title = "test"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

