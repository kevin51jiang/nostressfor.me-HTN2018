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
        statusItem.menu = statusMenu
        let icon = #imageLiteral(resourceName: "menuIcon")
        icon.isTemplate = true
        DispatchQueue.main.async {
            self.statusItem.button?.image = icon
        }
        
        ScriptingManager.initialize()
        
        let image = CIImage(contentsOf: URL(fileURLWithPath: "/Users/Nate/Downloads/test.jpg"))
        AzureClient.getExpressionInfo(image: image!) { _ in
            print("completion")
        }
        
        let asdf = Website(expression: Expression(anger: 0.5, contempt: 1, disgust: 0.2, fear: 0.5, neutral: 0.8, sadness: 0.123, surprise: 0), domain: "google.com")
        let jkl = Website(expression: Expression(anger: 0.1, contempt: 1, disgust: 0.2, fear: 0.5, neutral: 0.8, sadness: 0.123, surprise: 0), domain: "bing.com")
        DataManager.initialize()
        DataManager.websites.append(asdf)
        DataManager.websites.append(jkl)
        
        DataManager.generateJSON(path: URL(fileURLWithPath: "/Users/Nate/Desktop"))
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

