//
//  Prefs.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Foundation

struct Keys {
    
}

class PrefManager {
    static let shared = PrefManager()
    
    let userDefaults = UserDefaults.standard
}
