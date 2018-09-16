//
//  ScriptingBridge.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Cocoa
import ScriptingBridge

@objc protocol Browser {
    @objc optional var windows: SBElementArray { get }
}

@objc protocol Window {
    @objc optional var currentTab: Tab { get }
    @objc optional var activeTab: Tab { get }
}

@objc protocol Tab {
    @objc optional var URL: String { get }
}

extension SBApplication: Browser {
    convenience init?(_ application: NSRunningApplication) {
        self.init(processIdentifier: application.processIdentifier)
    }
}
extension SBObject: Window, Tab { }
