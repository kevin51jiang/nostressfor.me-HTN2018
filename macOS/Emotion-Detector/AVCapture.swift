//
//  AVCapture.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/16/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Cocoa

enum AVCapture {
    static func takePhoto() {
        DispatchQueue.main.async {
            let task = Process()
            task.arguments = ["imagesnap", "/Users/Nate/Desktop/expression.jpg"]
            task.launchPath = "/usr/local/bin/imagesnap"
            do {
                try task.run()
            } catch {
                NSLog("Could not run task")
            }
            task.waitUntilExit()
            
            //uploadPhoto()
        }
    }
}
