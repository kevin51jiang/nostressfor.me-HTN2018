//
//  ScriptingManager.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import ScriptingBridge
import AXSwift
import PublicSuffix

var browserObserver: Observer!

enum BrowserError: Error {
    case noWindow
}

typealias BundleIdentifier = String
enum SupportedBrowser: BundleIdentifier {
    typealias RawValue = String
    
    case safari = "com.apple.Safari"
    case safariTechnologyPreview = "com.apple.SafariTechnologyPreview"
    
    case chrome = "com.google.Chrome"
    case chromeCanary = "com.google.Chrome.canary"
    case chromium = "org.chromium.Chromium"
    case vivaldi = "com.vivaldi.Vivaldi"
    
    init?(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
    
    init?(_ application: NSRunningApplication) {
        if let bundleIdentifier = application.bundleIdentifier {
            self.init(bundleIdentifier)
        } else {
            return nil
        }
    }
}


enum ScriptingManager {
    static func initialize() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: nil) {
            appSwitched(notification: $0)
        }
    }
    
    static var currentApp: NSRunningApplication? {
        return NSWorkspace.shared.menuBarOwningApplication
    }
    
    static var currentURL: URL? {
        if !UIElement.isProcessTrusted() {
            return nil
        }
        
        guard let application = currentApp,
            let browser = SupportedBrowser(application),
            let app: Browser = SBApplication(application) else {
                return nil
        }
        
        do {
            let url = try urlFor(browser, app)
            return url
        } catch {
            do {
                let url = try urlFor(browser, app)
                return url
            } catch {
                return nil
            }
        }
    }
    
    static var currentDomain: String? {
        return currentURL?.registeredDomain
    }
    
    static var currrentAppIsSupportedBrowser: Bool {
        if !UIElement.isProcessTrusted() {
            return false
        }
        
        guard let currentApp = currentApp else { return false }
        return SupportedBrowser(currentApp) != nil
    }
    
    static var hasValidDomain: Bool {
        return currentDomain != nil
    }
    
    
    static func appSwitched(notification: Notification) {
        guard let app = NSWorkspace.shared.menuBarOwningApplication else { return }
        let pid = app.processIdentifier
        if !currrentAppIsSupportedBrowser {
            return
        }
        
        do {
            try startBrowserWatcher(pid) {
                let timer = DispatchSource.makeTimerSource()
                timer.schedule(deadline: .now() + 10)
                timer.setEventHandler(handler: {
                    AVCapture.takePhoto()
                })
            }
        } catch let error {
            NSLog("Error: Could not watch app [\(pid)]: \(error)")
        }
    }
    
    private static func startBrowserWatcher(_ processIdentifier: pid_t, callback: @escaping () -> Void) throws {
        if let app = Application(forProcessID: processIdentifier) {
            browserObserver = app.createObserver { (observer: Observer, element: UIElement, event: AXNotification, info: [String: AnyObject]?) in
                if event == .windowCreated {
                    do {
                        try browserObserver.addNotification(.titleChanged, forElement: element)
                    } catch let error {
                        NSLog("Error: Could not watch [\(element)]: \(error)")
                    }
                }
                if event == .titleChanged || event == .focusedWindowChanged {
                    DispatchQueue.main.async {
                        callback()
                    }
                }
            }
            
            do {
                let windows = try app.windows()!
                for window in windows {
                    do {
                        try browserObserver.addNotification(.titleChanged, forElement: window)
                    } catch let error {
                        NSLog("Error: Could not watch [\(window)]: \(error)")
                    }
                }
            } catch let error {
                NSLog("Error: Could not get windows for \(app): \(error)")
            }
            try browserObserver.addNotification(.focusedWindowChanged, forElement: app)
            try browserObserver.addNotification(.windowCreated, forElement: app)
        }
    }
    
    static func stopBrowserWatcher() {
        if browserObserver != nil {
            browserObserver.stop()
            browserObserver = nil
        }
    }
    
    static func urlFor(_ browser: SupportedBrowser, _ application: Browser) throws -> URL? {
        print(application.windows as! [Window])
        guard let window = (application.windows as? [Window])?.first else {
            throw BrowserError.noWindow
        }
        let tab: Tab?
        switch browser {
        case .safari, .safariTechnologyPreview:
            tab = window.currentTab
        case .chrome, .chromeCanary, .chromium, .vivaldi:
            tab = window.activeTab
        }
        return tab?.URL.flatMap(URL.init(string:))
    }
}
